-- ============================================
-- Proyecto : Credit Risk Analysis 2025
-- Autor    : Carlos Hernández
-- BD       : Credit_Risk
-- Tabla    : dbo.creditrisk_raw
-- Descripción:
--   Análisis de riesgo de impago para simular
--   el trabajo de un analista de datos en banca.
-- ============================================

-- 0. Seleccionar base de datos
USE Credit_Risk;
GO


/*================================================
  1. EXPLORACIÓN BÁSICA DE LA TABLA
==================================================*/

-- 1.1. Vista rápida de los datos
SELECT TOP 10 *
FROM dbo.creditrisk_raw;

-- 1.2. Número total de registros
SELECT 
    COUNT(*) AS total_registros
FROM dbo.creditrisk_raw;

-- 1.3. Distribución de la variable objetivo (loan_status)
--     0 = no default, 1 = default
SELECT 
    loan_status,
    COUNT(*) AS total_creditos,
    CAST(
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM dbo.creditrisk_raw)
        AS DECIMAL(5,4)
    ) AS porcentaje_sobre_total
FROM dbo.creditrisk_raw
GROUP BY loan_status
ORDER BY loan_status;


/*================================================
  2. KPI PRINCIPAL: TASA GLOBAL DE DEFAULT
==================================================*/

-- 2.1. Tasa de impago (default) global

SELECT 
    COUNT(*) AS total_creditos,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS creditos_en_default,
    CAST(
        SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 1.0 
        / COUNT(*) 
        AS DECIMAL(5,4)
    ) AS tasa_default_global
FROM dbo.creditrisk_raw;


/*================================================
  3. RIESGO POR GRUPOS DEMOGRÁFICOS
==================================================*/

-- 3.1. Default por grupo de edad
-- Segmentación de ejemplo:
--   18-25, 26-35, 36-45, 46-60, 61+

SELECT 
    CASE 
        WHEN person_age < 26 THEN '18-25'
        WHEN person_age BETWEEN 26 AND 35 THEN '26-35'
        WHEN person_age BETWEEN 36 AND 45 THEN '36-45'
        WHEN person_age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '61+'
    END AS age_group,
    COUNT(*) AS total_creditos,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS creditos_en_default,
    CAST(
        SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 1.0 
        / COUNT(*) 
        AS DECIMAL(5,4)
    ) AS tasa_default
FROM dbo.creditrisk_raw
GROUP BY 
    CASE 
        WHEN person_age < 26 THEN '18-25'
        WHEN person_age BETWEEN 26 AND 35 THEN '26-35'
        WHEN person_age BETWEEN 36 AND 45 THEN '36-45'
        WHEN person_age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '61+'
    END
ORDER BY tasa_default DESC;

-- 3.2. Default por segmento de ingreso
-- Segmentación ejemplo (anual):
--   Bajo :   < 30,000
--   Medio:   30,000 - 60,000
--   Alto :   > 60,000

SELECT 
    CASE 
        WHEN person_income < 30000 THEN 'Bajo (<30k)'
        WHEN person_income BETWEEN 30000 AND 60000 THEN 'Medio (30k-60k)'
        ELSE 'Alto (>60k)'
    END AS income_segment,
    COUNT(*) AS total_creditos,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS creditos_en_default,
    CAST(
        SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 1.0 
        / COUNT(*) 
        AS DECIMAL(5,4)
    ) AS tasa_default
FROM dbo.creditrisk_raw
GROUP BY 
    CASE 
        WHEN person_income < 30000 THEN 'Bajo (<30k)'
        WHEN person_income BETWEEN 30000 AND 60000 THEN 'Medio (30k-60k)'
        ELSE 'Alto (>60k)'
    END
ORDER BY tasa_default DESC;

-- 3.3. Default por nivel de endeudamiento
-- loan_percent_income = % del ingreso destinado al préstamo
-- Segmentación ejemplo:
--   Bajo :   < 0.20  (menos del 20%)
--   Medio:   0.20 - 0.40
--   Alto :   > 0.40

SELECT 
    CASE 
        WHEN loan_percent_income < 0.20 THEN 'Bajo (<20%)'
        WHEN loan_percent_income BETWEEN 0.20 AND 0.40 THEN 'Medio (20%-40%)'
        ELSE 'Alto (>40%)'
    END AS dti_segment,
    COUNT(*) AS total_creditos,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS creditos_en_default,
    CAST(
        SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 1.0 
        / COUNT(*) 
        AS DECIMAL(5,4)
    ) AS tasa_default
FROM dbo.creditrisk_raw
GROUP BY 
    CASE 
        WHEN loan_percent_income < 0.20 THEN 'Bajo (<20%)'
        WHEN loan_percent_income BETWEEN 0.20 AND 0.40 THEN 'Medio (20%-40%)'
        ELSE 'Alto (>40%)'
    END
ORDER BY tasa_default DESC;


/*================================================
  4. PERFIL COMPARATIVO:
     CLIENTES EN DEFAULT VS NO DEFAULT
==================================================*/

SELECT 
    loan_status,                      -- 0 = no default, 1 = default
    COUNT(*) AS total_creditos,
    AVG(person_income) AS ingreso_promedio,
    AVG(loan_amnt) AS monto_prestamo_promedio,
    AVG(loan_percent_income) AS promedio_loan_percent_income,
    AVG(cb_person_cred_hist_length) AS promedio_hist_cred_anios
FROM dbo.creditrisk_raw
GROUP BY loan_status;


/*================================================
  5. RIESGO SEGÚN HISTORIAL EN BURÓ
==================================================*/

-- cb_person_default_on_file:
--   0 = no tiene default previo en buró
--   1 = sí tiene default previo

SELECT 
    cb_person_default_on_file,
    COUNT(*) AS total_creditos,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS creditos_en_default,
    CAST(
        SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 1.0
        / COUNT(*)
        AS DECIMAL(5,4)
    ) AS tasa_default
FROM dbo.creditrisk_raw
GROUP BY cb_person_default_on_file
ORDER BY tasa_default DESC;


/*================================================
  6. RIESGO SEGÚN FINALIDAD DEL PRÉSTAMO
==================================================*/

-- loan_intent: finalidad del préstamo (educación, auto, personal, etc.)

SELECT 
    loan_intent,
    COUNT(*) AS total_creditos,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS creditos_en_default,
    CAST(
        SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 1.0 
        / COUNT(*) 
        AS DECIMAL(5,4)
    ) AS tasa_default
FROM dbo.creditrisk_raw
GROUP BY loan_intent
ORDER BY tasa_default DESC;


/*================================================
  7. SEGMENTOS DE RIESGO (LÓGICA DE NEGOCIO)
==================================================*/

-- Ejemplo de lógica:
--   Riesgo Alto : loan_percent_income > 0.40
--                 O historial previo en buró (cb_person_default_on_file = 1)
--   Riesgo Medio: loan_percent_income entre 0.20 y 0.40
--                 Y sin default previo (cb_person_default_on_file = 0)
--   Riesgo Bajo : resto de clientes

SELECT 
    CASE 
        WHEN loan_percent_income > 0.40 
             OR cb_person_default_on_file = 1 THEN 'Alto'
        WHEN loan_percent_income BETWEEN 0.20 AND 0.40 
             AND cb_person_default_on_file = 0 THEN 'Medio'
        ELSE 'Bajo'
    END AS risk_segment,
    COUNT(*) AS total_creditos,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS creditos_en_default,
    CAST(
        SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 1.0
        / COUNT(*)
        AS DECIMAL(5,4)
    ) AS tasa_default
FROM dbo.creditrisk_raw
GROUP BY 
    CASE 
        WHEN loan_percent_income > 0.40 
             OR cb_person_default_on_file = 1 THEN 'Alto'
        WHEN loan_percent_income BETWEEN 0.20 AND 0.40 
             AND cb_person_default_on_file = 0 THEN 'Medio'
        ELSE 'Bajo'
    END
ORDER BY tasa_default DESC;


-- ============================================
-- Fin del script de análisis SQL
-- Archivo: 05_sql/sql_creditrisk_analysis.sql
-- ============================================
