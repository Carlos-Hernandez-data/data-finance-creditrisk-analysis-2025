# Análisis de Riesgo Crediticio — Credit Risk

**Autor:** Carlos Hernández Godoy  
**Perfil:** Analista de Datos | Ingeniero Industrial  
**Año:** 2025  

## Descripción general

Este repositorio contiene un análisis de riesgo crediticio orientado a evaluar la **probabilidad de impago** y a identificar **perfiles de clientes con mayor riesgo**, utilizando SQL y Power BI como herramientas principales.

El trabajo integra exploración de datos, definición de métricas clave, segmentación de riesgo y visualización ejecutiva, con el objetivo de apoyar decisiones relacionadas con aprobación de crédito, priorización de clientes y gestión del riesgo.

## Objetivos del análisis

- Medir la **tasa de impago** del portafolio y su comportamiento por distintos segmentos.
- Identificar los principales **drivers de riesgo crediticio**, como endeudamiento, historial previo y finalidad del préstamo.
- Construir una **segmentación clara de riesgo** (bajo, medio, alto) que facilite la toma de decisiones.
- Presentar los resultados en un **dashboard ejecutivo** claro y comprensible para usuarios no técnicos.

## Estructura del repositorio
```
data-finance-creditrisk-analysis-2025/
├── 01_data/ (creditrisk_raw.csv)
├── 02_dax/ (dax_measures_creditrisk.txt)
├── 03_img/ (executive_dashboard.png)
├── 04_pbix/ (creditrisk_dashboard.pbix)
├── 05_sql/ (sql_creditrisk_analysis.sql)
└── 06_README.md
```
## Datos utilizados

- **Fuente:** Credit Risk Dataset (Kaggle)
- **Tema:** Riesgo crediticio y comportamiento de pago
- **Variable objetivo:** `loan_status`  
  - 0 = no impago  
  - 1 = impago  

Las columnas del dataset se mantienen en inglés para consistencia técnica con la fuente original.  
La narrativa del dashboard (títulos, etiquetas y slicers) se presenta en español para facilitar la interpretación por usuarios de negocio.

## Enfoque analítico

El análisis se centra en métricas orientadas a decisión, evitando redundancia:

- **Tasa de impago (Default Rate)** como indicador principal.
- Evaluación del riesgo según:
  - nivel de endeudamiento (deuda sobre ingreso),
  - historial previo de impago,
  - nivel de ingresos,
  - grupo de edad,
  - finalidad del préstamo.
- Definición de un **segmento de riesgo ejecutivo** que combina variables financieras y comportamiento histórico.

El enfoque prioriza la coherencia entre métricas, segmentación y visualización, asegurando que cada gráfico aporte información accionable.

## Herramientas y tecnologías

### SQL Server
- Exploración de datos y validación de supuestos.
- Cálculo de métricas clave y análisis por segmentos.
- Segmentación de riesgo y análisis comparativo.
- Archivo: `05_sql/sql_creditrisk_analysis.sql`

### Power BI
- Limpieza ligera y tipificación de datos en Power Query.
- Columnas calculadas para segmentación y visualización.
- Medidas DAX mínimas y orientadas a negocio.
- Dashboard ejecutivo de una sola página.
- Archivo: `04_pbix/creditrisk_dashboard.pbix`

### IA (ChatGPT)
- Apoyo en la estructuración del análisis y definición de hipótesis.
- Validación conceptual de métricas y segmentaciones.
- Asistencia en documentación y claridad narrativa.

La IA se utilizó como **herramienta de apoyo**, sin sustituir el criterio analítico ni la interpretación de resultados.

## Modelado y lógica de segmentación

El modelo se basa en una tabla principal (`creditrisk_raw`) complementada con columnas calculadas para facilitar el análisis:

- **Grupo de edad**
- **Nivel de ingresos**
- **Nivel de endeudamiento (DTI)**
- **Nivel de riesgo** (bajo / medio / alto)
- **Loan Purpose (ES)**
- **Historial previo de impago (Sí / No)**

Las medidas DAX se mantuvieron deliberadamente acotadas para evitar complejidad innecesaria y garantizar claridad en el dashboard.

Todas las columnas calculadas y medidas están documentadas en:  
`02_dax/dax_measures_creditrisk.txt`.

## Dashboard — Resumen Ejecutivo

El dashboard está diseñado para una lectura rápida y enfocada en decisiones:

- KPIs principales:
  - total de créditos analizados,
  - tasa global de impago,
  - monto promedio del préstamo,
  - endeudamiento promedio,
  - porcentaje de clientes con historial previo de impago.
- Comparación del riesgo por:
  - segmento de riesgo,
  - nivel de endeudamiento,
  - nivel de ingresos,
  - grupo de edad,
  - finalidad del préstamo.
- Segmentadores para explorar distintos escenarios del portafolio.

**Archivo:** `04_pbix/creditrisk_dashboard.pbix`  
**Captura:** `03_img/executive_dashboard.png`

## Principales insights

- La **tasa global de impago** del portafolio es de **21.82%**, lo que evidencia un nivel de riesgo relevante que requiere segmentación para una mejor toma de decisiones crediticias.
- El **segmento de alto riesgo** concentra la mayor probabilidad de impago (**42.35%**), superando claramente a los segmentos de riesgo medio (**30.37%**) y bajo (**10.37%**).
- El **endeudamiento** actúa como uno de los principales drivers del riesgo: a mayor deuda sobre ingreso, mayor probabilidad de impago, alcanzando valores especialmente elevados en el nivel de endeudamiento alto.
- Los clientes con **historial previo de impago** presentan una tasa de impago significativamente superior a aquellos sin historial (**37.81% vs 18.39%**), confirmando el comportamiento pasado como un fuerte predictor de riesgo futuro.
- La **finalidad del préstamo** con mayor riesgo relativo es **Consolidación de deudas**, con una tasa de impago de **54.44%**, muy por encima del promedio general del portafolio.
- Existen diferencias relevantes por **nivel de ingresos y grupo de edad**, lo que permite ajustar políticas de evaluación, segmentación y condiciones de otorgamiento de crédito.

## Conclusión

Este análisis muestra cómo el uso combinado de SQL, Power BI y una correcta definición de métricas permite entender el riesgo crediticio de forma estructurada y accionable.
El trabajo refleja un enfoque de analista orientado a negocio: métricas claras, segmentación consistente y comunicación visual pensada para apoyar decisiones reales en contextos financieros.

## Contacto

Carlos Hernández Godoy  
Analista de Datos | SQL · Power BI · Análisis de Riesgo  
Correo: carloshernandez.data@gmail.com