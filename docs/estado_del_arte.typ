#set page(columns: 2)

= Estado del Arte

== Introducción

El advenimiento del big data ha hecho necesaria la creación de arquitecturas capaces de ingerir, procesar y analizar de manera eficiente grandes volúmenes de datos en tiempo real. Esta revisión de literatura explora dos arquitecturas de procesamiento de datos prominentes: las arquitecturas Lambda y Kappa. También cubriremos las evoluciones de estas arquitecturas, los desafíos que enfrentan y cómo algunas tecnologías nuevas y emergentes se han hecho un lugar en componentes específicos de esas arquitecturas. Luego profundizaremos en cómo las arquitecturas basadas en eventos están cambiando la forma en que pensamos sobre el procesamiento de datos y haremos énfasis en los marcos de procesamiento de eventos complejos (CEP) existentes, qué son y cómo orquestan eventos en un pipeline de procesamiento de datos. Por último, cubriremos el surgimiento de una nueva tecnología prometedodora llamada StreamCube, que aprovecha tanto el procesamiento por lotes como el procesamiento en tiempo real para proporcionar una nueva forma de consultar datos.

== Visión general

=== ¿Qué es el big data?

El big data es lo que llamamos una gran cantidad de datos que no se pueden ingerir, procesar y almacenar utilizando técnicas convencionales. Estos pueden venir en diferentes formas como redes sociales, información de sensores, ciudades inteligentes, telemetría de dispositivos móviles, etc. Las características del big data a menudo se describen mediante las tres V: Volumen, Velocidad y Variedad. Volumen se refiere a la cantidad de datos que se están generando, Velocidad se refiere a la velocidad a la que se generan y procesan los datos, y Variedad se refiere a los diferentes tipos de datos que se generan. Se han agregado otras V a la definición de big data como Veracidad y Valor. Veracidad se refiere a la calidad de los datos y Valor se refiere a las ideas que se pueden extraer de los datos.

=== ETL

ETL, que significa Extraer, Transformar y Cargar, es un proceso fundamental en el almacenamiento de datos y la integración de datos. Implica extraer datos de varias fuentes, transformarlos a un formato estandarizado y luego cargarlos en un data warehouse u otro sistema de destino para análisis, generación de informes y toma de decisiones basada en datos. @big-archive

El paso inicial en el proceso ETL involucra la extracción de datos de múltiples fuentes. Estas fuentes pueden incluir bases de datos relacionales, bases de datos NoSQL, archivos planos, hojas de cálculo y servicios web. Los datos extraídos generalmente se almacenan en un área de preparación, que es una ubicación temporal que se utiliza para almacenar los datos antes de que se transformen.

Durante la fase de transformación, los datos extraídos se limpian, validan y convierten a un formato adecuado para el análisis. Esto puede implicar varias operaciones como filtrar, limpiar (manejar valores faltantes, corregir errores), unir datos de múltiples fuentes, dividir atributos y ordenar datos. El objetivo es garantizar que los datos sean precisos, coherentes y estén en un formato que cumpla con los requisitos del data warehouse y las consultas analíticas que se ejecutarán contra él.

El paso final en el proceso ETL es cargar los datos transformados en el sistema de destino, que a menudo es un data warehouse. El data warehouse está diseñado para consolidar datos de diversas fuentes en una vista única e integrada, lo que facilita la realización de análisis complejos y la generación de informes perspicaces. Cargar los datos en el almacén implica crear los esquemas y tablas necesarios e insertar los datos en estas estructuras.

=== ELT

ELT, que significa Extraer, Cargar y Transformar, es la contraparte de un pipeline ETL, donde los datos vienen en un formato no estructurado y, por lo tanto, no se pueden transformar directamente, por lo que pasan directamente a la carga en un data lake, para su futura transformación. Lo que hace cada paso no difiere de un proceso ETL (generalmente) @big-archive.

=== Tres formas diferentes de procesar datos

Hoy en día existen principalmente tres formas de procesar datos: procesamiento por lotes, procesamiento en tiempo real y procesamiento de streams. El procesamiento por lotes es la forma tradicional de procesar datos donde los datos se recolectan durante un período de tiempo y luego se procesan de una sola vez en lotes, lo cual es particularmente eficiente debido a algunas tecnologías que veremos más adelante. El procesamiento de datos en tiempo real implica analizar y actuar sobre los datos tan pronto como están disponibles. El procesamiento de streams se ocupa de flujos continuos de datos a medida que fluyen a través de un sistema, lo que implica ordenar, filtrar y agregar datos. El procesamiento en tiempo real y el procesamiento de streams a menudo van de la mano cuando se requiere un análisis en tiempo real, por lo que no es raro verlos referenciados en la literatura como un paradigma único, por lo que usaré sus nombres indistintamente.

Dependiendo del caso de uso, los datos pueden volverse obsoletos en diferentes períodos de tiempo. Es una regla general que los datos que pueden volverse obsoletos en un corto período de tiempo deben procesarse en tiempo real, mientras que los datos que pueden volverse obsoletos en un período de tiempo más largo se pueden procesar por lotes. Ejemplos de escenarios de procesamiento por lotes pueden ser cuando se extraen datos para entrenar un modelo de aprendizaje automático, siempre que los datos sean precisos y no estén sujetos a la deriva de datos, funcionarán. Los ejemplos de datos de stream pueden ser signos vitales de un paciente hospitalizado, que deben analizarse con la menor latencia posible, ya que un paso mínimo puede hacer que las enfermeras y los médicos no respondan a tiempo.


=== Arquitectura Lambda

Propuesta por Nathan Marz, es una arquitectura de procesamiento de datos diseñada para manejar grandes cantidades de datos aprovechando los métodos de procesamiento por lotes y por streams. La arquitectura se compone de tres capas: la capa batch (lote), la capa de velocidad y la capa de servicio. La capa batch es responsable de almacenar y procesar grandes cantidades de datos de manera tolerante a fallos. La capa de velocidad es responsable de procesar datos en tiempo real y proporcionar resultados actualizados. La capa de servicio se encarga de consultar y servir los resultados de las capas batch y de velocidad. La arquitectura Lambda está diseñada para ser tolerante a fallos, escalable y extensible @marz @fundamentals-lambda-kappa

=== Arquitectura Kappa

Introducida por Jay Kreps, la arquitectura Kappa simplifica el modelo Lambda eliminando la capa batch, confiando así únicamente en el procesamiento de streams. Este enfoque tiene como objetivo reducir la complejidad y la latencia asociadas con el mantenimiento de sistemas batch y en tiempo real separados @fundamentals-lambda-kappa.

=== EDA y CEP

EDA (Arquitectura Dirigida por Eventos) es un paradigma de diseño donde el flujo del programa está determinado por eventos como acciones del usuario, salidas de sensores o mensajes de otros programas. En EDA, los componentes producen, detectan, consumen y reaccionan a eventos. Esta arquitectura admite el procesamiento interactivo en tiempo real y es muy adecuada para escenarios como el Internet de las cosas (IoT), donde los dispositivos generan y consumen eventos. Los componentes clave de EDA incluyen productores de eventos, canales de eventos y consumidores de eventos. Los productores crean mensajes de eventos que fluyen a través de canales hacia los consumidores, quienes luego toman acciones específicas basadas en los eventos. Esta configuración asegura un acoplamiento débil entre componentes, lo que permite escalabilidad y flexibilidad. EDA permite que aplicaciones dispares interactúen de manera efectiva, facilitando una respuesta rápida a dependencias de eventos simples y complejos @cep.

CEP (Procesamiento de Eventos Complejos) se extiende más allá del procesamiento de eventos simples al lidiar con patrones, combinaciones y correlaciones de eventos. Implica detectar y gestionar relaciones complejas entre eventos, que pueden ser causales, temporales o espaciales. Los sistemas CEP analizan flujos de datos en tiempo real para identificar patrones y conocimientos significativos, lo que permite respuestas proactivas y oportunas a las oportunidades o amenazas comerciales. A diferencia del procesamiento de eventos simple, CEP considera datos históricos y agregaciones, proporcionando una vista más completa de los datos. Esta capacidad es crucial para las industrias donde la toma de decisiones en tiempo real es vital, como finanzas, atención médica y transporte @cep.

=== Una nueva arquitectura

StreamCube es una arquitectura de procesamiento de datos novedosa que combina el procesamiento por lotes y por streams para proporcionar un enfoque unificado para consultar datos. Aprovecha las fortalezas del procesamiento por lotes y por streams para ofrecer análisis en tiempo real en conjuntos de datos a gran escala. StreamCube está diseñado para manejar consultas complejas de manera eficiente al dividir los datos en cubos y procesarlos en paralelo. Esta arquitectura permite a los usuarios consultar datos en tiempo real, proporcionando información sobre los datos a medida que llegan. @streamcube

== Tecnologías y herramientas

=== La familia Apache

La Apache Software Foundation ofrece un ecosistema robusto de herramientas de código abierto diseñadas para abordar una amplia gama de desafíos del big data. Este conjunto, a menudo denominado "familia Apache", abarca diversos proyectos que atienden a diferentes aspectos de la gestión y el procesamiento de datos. En el núcleo, Apache Hadoop proporciona un marco escalable para el almacenamiento y procesamiento distribuidos de grandes conjuntos de datos utilizando el modelo de programación MapReduce. Complementando a Hadoop se encuentran Apache Spark, un sistema informático en clúster rápido y de propósito general para el procesamiento de datos en tiempo real, y Apache Flink, conocido por sus eficientes capacidades de procesamiento por lotes y streams. Estas herramientas son esenciales para procesar volúmenes masivos de datos con alto rendimiento y confiabilidad.

Más allá de los marcos de procesamiento centrales, la familia Apache incluye una gama de software especializado. Apache Cassandra y Apache HBase ofrecen soluciones de bases de datos distribuidas optimizadas para manejar datos a gran escala y alta velocidad en numerosos servidores con una latencia mínima. Para la transmisión de datos en tiempo real, Apache Kafka es un agente de mensajes altamente confiable que admite feeds de datos de alto rendimiento y baja latencia. Apache Hive y Apache Pig simplifican la consulta y el análisis de grandes conjuntos de datos almacenados en Hadoop. Este conjunto completo es fundamental para las organizaciones que desean aprovechar el big data para obtener información, impulsar la innovación y la eficiencia operativa. Cada herramienta dentro de la familia Apache está diseñada para integrarse perfectamente, proporcionando una solución cohesiva y escalable para diversas necesidades de big data.

=== Apache Hadoop

Apache Hadoop es un marco poderoso diseñado para procesar grandes volúmenes de datos en clusters de computadoras utilizando modelos de programación simples. Está construido para escalar desde servidores individuales hasta miles de máquinas, cada una de las cuales ofrece computación y almacenamiento local. En el corazón de Hadoop se encuentra el modelo de programación MapReduce, que permite el procesamiento de grandes cantidades de datos en paralelo en grandes clusters de hardware básico de manera confiable y tolerante a fallas @hadoop

==== ¿Cómo funciona MapReduce?

MapReduce es un marco de software para escribir aplicaciones que procesan grandes cantidades de datos en paralelo en grandes clusters de hardware básico. Simplifica el proceso de tratar con grandes conjuntos de datos al dividir el trabajo en tareas más pequeñas que se pueden ejecutar de forma independiente y en paralelo. Este enfoque mejora significativamente la eficiencia y el rendimiento, especialmente cuando se trata de conjuntos de datos de varios terabytes @hadoop. Funciona de la siguiente manera:

- *Entrada*: Un trabajo de MapReduce generalmente comienza con un conjunto de datos almacenado en un sistema de archivos distribuido como Hadoop Distributed File System (HDFS). Los datos de entrada se dividen en fragmentos independientes, que son procesados por las tareas de mapeo en paralelo.

- *Fase de Mapeado*: La función de mapeado procesa cada fragmento de datos, transformando la entrada en un conjunto de pares clave-valor intermedios. Esta fase es altamente paralelizable, lo que permite un procesamiento eficiente de grandes conjuntos de datos.

- *Mezcla y ordenamiento*: Después de la fase de mapeado, los pares clave-valor intermedios se barajan y ordenan. Este paso organiza los datos de una manera óptima para la fase de reducción.

- *Fase de Reducción*: La función de reducción toma los pares clave-valor ordenados como entrada y los combina para producir la salida final. Esta fase también está paralelizada, lo que mejora aún más la eficiencia del proceso.

- *Salida*: Los resultados de la fase de reducción generalmente se almacenan nuevamente en el sistema de archivos distribuido, listos para su posterior procesamiento o análisis.

MapReduce es particularmente útil cuando se realizan trabajos de procesamiento por lotes, pero no cuando se manejan datos en streaming, como veremos más adelante.

=== Apache Kafka

Apache Kafka es una plataforma de streaming de datos distribuida diseñada para el procesamiento de datos en tiempo real. Está optimizada para la ingesta y el procesamiento de datos en streaming, lo que la hace adecuada para construir pipelines y aplicaciones de datos en streaming en tiempo real. La arquitectura de Kafka le permite manejar la afluencia constante de datos de miles de fuentes de datos, procesando estos datos de manera secuencial e incremental. Combina funcionalidades de mensajería, almacenamiento y procesamiento de streams para permitir el almacenamiento y análisis de datos tanto históricos como en tiempo real @kafka

Kafka opera con un modelo de publicación-suscripción, donde los datos se publican en temas (topics) y los suscriptores (consumers) los consumen. Este modelo facilita la distribución eficiente de datos entre varios consumidores, lo que garantiza un procesamiento de datos de baja latencia y alto rendimiento. La capacidad de Kafka para procesar flujos de datos en tiempo real admite la ingesta continua de datos y el análisis en tiempo real, lo que permite a las empresas tomar decisiones oportunas basadas en datos.

Los componentes clave de Kafka incluyen productores, consumidores, temas (topics) y eventos. Los productores son aplicaciones cliente que insertan eventos en temas, los cuales son registros categorizados y almacenados que contienen eventos en un orden lógico. Los consumidores son aplicaciones que leen y procesan eventos de estos temas. Los eventos representan registros de cambios en el estado del sistema, transmitidos como parte de la plataforma de streaming de eventos de Kafka.

Los beneficios de Kafka se extienden más allá de su funcionalidad principal. Ofrece velocidades de procesamiento más rápidas en comparación con otras plataformas, lo que permite la transmisión de datos en tiempo real con una latencia casi nula. Esta capacidad es crucial para realizar análisis de datos en tiempo real y tomar decisiones comerciales rápidas. Además, Kafka Connect, un componente de Apache Kafka, funciona como un centro de datos centralizado, facilitando la integración entre varios sistemas de datos y acelerando el desarrollo de aplicaciones. La escalabilidad y durabilidad de Kafka garantizan que los clusters de producción se puedan ajustar según la demanda, y la tolerancia a fallos y la replicación dentro del cluster brindan una alta durabilidad para los datos que maneja.

=== Apache Spark

Apache Spark es un motor de análisis unificado diseñado para el procesamiento de datos a gran escala. Es conocido por su velocidad, facilidad de uso y versatilidad, lo que lo convierte en una opción popular para el procesamiento de datos por lotes y en tiempo real. La arquitectura de Spark admite una amplia gama de tareas de procesamiento de datos, que incluyen ETL (Extracción, transformación, carga), almacenamiento de datos, aprendizaje automático y procesamiento de gráficos. Puede operar con datos almacenados en varios formatos y ubicaciones, como HDFS, HBase, Cassandra y cualquier fuente de datos compatible con HDFS @spark

Spark Streaming es un componente de Apache Spark que permite el procesamiento de datos en tiempo real. Permite a los usuarios procesar flujos de datos en vivo en tiempo real, lo que lo hace adecuado para aplicaciones que requieren información inmediata de los datos entrantes. Spark Streaming logra esto dividiendo el flujo de datos en microlotes, procesando cada microlote como un RDD (Conjunto de Datos Distribuidos Resilientes) separado. Luego, estos RDD se pueden transformar y procesar utilizando las operaciones estándar de Spark, como mapear, filtrar y reducir por clave.

- *Conjuntos de Datos Distribuidos Resilientes (RDDs)*: Los RDD son la estructura de datos fundamental de Spark. Son una colección distribuida e inmutable de objetos. Cada conjunto de datos en RDD se divide en particiones lógicas, que pueden calcularse en diferentes nodos del cluster. Los RDD admiten dos tipos de operaciones: transformaciones, que crean un nuevo conjunto de datos a partir de uno existente, y acciones, que devuelven un valor al programa controlador después de ejecutar un cálculo en el conjunto de datos.

- *Grafo Acíclico Dirigido (DAG)*: Spark utiliza un enfoque basado en DAG para ejecutar transformaciones. Las transformaciones se optimizan y ejecutan en etapas, donde cada etapa consta de una o más tareas. Las tareas son la unidad de trabajo más pequeña enviada a los ejecutores. Los ejecutores ejecutan tareas en paralelo, aprovechando los recursos del cluster subyacente de manera eficiente.

La arquitectura de Spark incluye varios componentes, como el Programa Driver, el Administrador del Cluster, el Executor y la Capa de Almacenamiento. El Programa Driver envía tareas al administrador del cluster, quien las programa en los nodos ejecutores. Los ejecutores ejecutan tareas y almacenan datos intermedios en memoria o disco, según la configuración. La Capa de Almacenamiento maneja el almacenamiento y la recuperación de datos, a menudo interconectándose con sistemas de almacenamiento distribuido como HDFS.

=== Apache Storm


Apache Storm es un sistema de computación distribuido en tiempo real diseñado para procesar flujos ilimitados de datos con alto rendimiento y baja latencia. A menudo se describe como lo que hizo Hadoop para el procesamiento por lotes, enfatizando su papel en habilitar análisis en tiempo real, aprendizaje automático en línea, computación continua, RPC distribuido, ETL y más. La arquitectura y las características de Storm lo convierten en una herramienta poderosa para manejar tareas de procesamiento de datos en tiempo real, lo que garantiza que los datos se procesen de manera confiable y eficiente. @storm

Apache Storm está diseñado para el procesamiento de datos en tiempo real. Su arquitectura gira en torno a spouts y bolts, que son los componentes principales de una topología de Storm.

- *Spouts*: Estas son las fuentes de flujos de datos en Storm. Ingestan datos de diversas fuentes como colas de mensajes, archivos de registro, bases de datos, API u otros productores de datos. Los spouts emiten datos en forma de tuplas a la topología de Storm para su procesamiento.

- *Bolts*: Los bolts son unidades de procesamiento dentro de una topología de Storm. Reciben tuplas de entrada, realizan cálculos o transformaciones y emiten tuplas de salida. Los bolts se pueden encadenar para crear canalizaciones de procesamiento complejas.

Estos componentes trabajan juntos para habilitar el procesamiento de datos en tiempo real en Storm. La salida de un spout se conecta a la entrada de bolts, y la salida de un bolt se conecta a la entrada de otros bolts, formando un grafo acíclico dirigido (DAG) que define el flujo de datos a través de la topología.

=== Apache Flink

Apache Flink es un marco potente y de código abierto, y un motor de procesamiento distribuido diseñado para cálculos con estado sobre flujos de datos ilimitados y acotados. Destaca por su capacidad para realizar cálculos a velocidades en memoria y a cualquier escala, lo que lo hace adecuado para una amplia gama de aplicaciones, desde análisis en tiempo real hasta procesamiento complejo de eventos. @flink

Se basa en el concepto de DataStream API, que permite a los usuarios definir y ejecutar canalizaciones de procesamiento de datos en datos en streaming. La arquitectura de Flink admite tanto el procesamiento por lotes como el por streaming, lo que permite a los usuarios cambiar sin problemas entre los dos modos. Esta flexibilidad es particularmente útil para aplicaciones que requieren capacidades de procesamiento por lotes y en tiempo real.

La arquitectura de Flink está diseñada para escalar y procesar de manera eficiente conjuntos de datos grandes casi en tiempo real, proporcionando tolerancia a fallas y permitiendo reiniciar trabajos con una pérdida mínima de datos. Funciona en un modelo maestro/esclavo con dos componentes clave:

- *JobManager*: Responsable de programar y administrar los trabajos enviados a Flink, orquestando el plan de ejecución mediante la asignación de recursos para las tareas.
- *TaskManagers*: Ejecutan funciones definidas por el usuario en recursos asignados en varios nodos de un cluster, manejando las tareas de computación reales.

=== Apache Cassandra

Apache Cassandra es una base de datos distribuida altamente escalable y de alto rendimiento diseñada para manejar grandes cantidades de datos en múltiples servidores comunes, proporcionando alta disponibilidad sin un único punto de falla. A menudo se usa en escenarios que requieren procesamiento de datos en tiempo real y procesamiento por lotes debido a su capacidad para manejar cargas de escritura altas y proporcionar tiempos de lectura rápidos. Exploremos cómo Cassandra se puede utilizar para escenarios de procesamiento en tiempo real y por lotes. @cassandra

Cassandra se adapta bien al procesamiento de datos en tiempo real, especialmente cuando se trata de transacciones de alto volumen. Su diseño enfatiza la alta disponibilidad, la tolerancia a particiones y la consistencia eventual, lo que la convierte en una excelente opción para aplicaciones que requieren un rendimiento constante bajo cargas pesadas. Para aplicaciones en tiempo real, como almacenes de características, Cassandra puede servir características con una latencia p99 típica de menos de 23 milisegundos, como lo demuestra su uso por empresas como Uber y Netflix.

La capacidad de Cassandra para manejar cargas de escritura altas con un impacto mínimo en la latencia de lectura la hace ideal para escenarios donde los datos necesitan actualizarse con frecuencia y accederse rápidamente. Esta característica es particularmente beneficiosa para los almacenes de características en tiempo real, donde las características se calculan en tiempo real y luego se pueden volver a calcular por lotes, y las discrepancias se actualizan tanto en el sistema en tiempo real como en el por lotes.

Si bien Cassandra brilla en escenarios en tiempo real, también admite el procesamiento por lotes a través de su compatibilidad con Hadoop, lo que le permite integrarse con trabajos de procesamiento por lotes basados en Hadoop. Esta integración permite el uso de Cassandra como un almacén de datos para tareas de procesamiento por lotes, como la agregación y el análisis de datos, aprovechando el marco MapReduce de Hadoop.

=== Apache Flume

Apache Flume es un sistema distribuido, confiable y disponible diseñado para recolectar, agregar y mover de manera eficiente grandes volúmenes de datos en streaming. Originado en Cloudera y ahora desarrollado por la Apache Software Foundation, Flume se usa ampliamente en entornos de big data para ingestar archivos de registro, datos de redes sociales, flujos de clics y otras fuentes de datos de alto volumen. Su objetivo principal es simplificar el proceso de ingestión de datos, asegurando una entrega confiable y tolerancia a fallos en sistemas distribuidos. Flume admite la ingestión de datos de diversas fuentes, incluidos servidores web, bases de datos y registros de aplicaciones, y facilita el flujo de datos a un sistema de archivos distribuido o un lago de datos donde puede ser analizado por marcos de procesamiento de datos como Apache Hadoop y Apache Spark. @flume

Flume opera con un diseño modular con componentes personalizables, lo que permite arquitecturas flexibles y escalables. Es particularmente adecuado para recolectar archivos de registro de diferentes fuentes, como servidores web, servidores de aplicaciones y dispositivos de red, y luego transportarlos a sistemas de almacenamiento o análisis centralizados. Esto lo convierte en una herramienta esencial para el análisis de big data, lo que permite a las organizaciones analizar grandes cantidades de datos de manera eficiente.

La arquitectura de Flume se basa en flujos de datos en streaming, lo que la hace robusta y tolerante a fallas con mecanismos de confiabilidad ajustables y numerosas opciones de conmutación por error y recuperación. Emplea un modelo de datos simple pero extensible que admite aplicaciones de análisis en línea, lo que mejora aún más su utilidad en los procesos de toma de decisiones basados en datos.

=== MongoDB

MongoDB es una base de datos NoSQL de código abierto altamente versátil que sobresale en el procesamiento de big data debido a sus características y arquitectura únicas. Está diseñada para manejar grandes volúmenes de datos con facilidad, ofreciendo alto rendimiento, disponibilidad y escalabilidad.

MongoDB está diseñada para ofrecer alto rendimiento y escalabilidad, lo que la hace adecuada para el procesamiento de big data. Puede escalar horizontalmente con facilidad para adaptarse a los crecientes volúmenes de datos y cargas de usuarios.

A diferencia de las bases de datos relacionales tradicionales, MongoDB almacena datos en formato BSON (JSON binario), lo que permite modelos de datos flexibles sin esquema. Esta flexibilidad es particularmente beneficiosa para manejar tipos y estructuras de datos variados comunes en escenarios de big data.

MongoDB admite el procesamiento de datos en tiempo real a través de su marco de trabajo de canalización de agregación y la integración con herramientas como Kafka y Spark. Esto permite la ingestión y el procesamiento eficientes de los datos a medida que llegan, lo que la hace ideal para aplicaciones que requieren información inmediata de flujos de datos.

MongoDB se puede integrar con el ecosistema Hadoop, lo que permite el procesamiento de grandes conjuntos de datos mediante MapReduce y otras herramientas de procesamiento de big data. Esta integración facilita el análisis de big data en las plataformas MongoDB y Hadoop.

MongoDB emplea fragmentación para distribuir datos en múltiples servidores, permitiendo el escalado horizontal. La fragmentación permite que MongoDB maneje grandes volúmenes de datos distribuyendo la carga entre un cluster de servidores, mejorando el rendimiento y la disponibilidad.

=== Esper

Esper es un motor CEP de código abierto que permite la creación de consultas de eventos complejos utilizando una sintaxis similar a SQL. Esper está diseñado para ejecutarse en una sola máquina, lo que lo hace adecuado para aplicaciones ligeras o entornos de desarrollo. @esper

Esper funciona buscando continuamente patrones predefinidos en los flujos de eventos entrantes. Cuando se encuentra una coincidencia, genera un "evento complejo", que puede activar alertas, notificaciones o acciones adicionales según la lógica definida. Esto hace que Esper sea muy versátil para aplicaciones que van desde la detección de fraudes hasta el monitoreo de procesos de fabricación.

La arquitectura de Esper está diseñada en torno al concepto de procesamiento de eventos, donde los eventos se ingieren de varias fuentes, se procesan de acuerdo con reglas definidas por el usuario y luego se actúan sobre ellos o se almacenan para un análisis posterior. Los componentes centrales de la arquitectura de Esper incluyen:

- *Entrada de eventos*: Los eventos pueden provenir de una variedad de ubicaciones, incluidas bases de datos, sistemas de archivos o feeds directos de sistemas externos.
- *Motor de reglas*: En el corazón de Esper, el motor de reglas evalúa los eventos entrantes con un conjunto de reglas predefinidas. Estas reglas especifican las condiciones bajo las cuales se debe generar un evento complejo.
- *Acciones de salida*: Una vez que se detecta un evento complejo, Esper puede realizar una variedad de acciones, como enviar notificaciones, activar alertas o invocar sistemas externos para tomar medidas correctivas.
- *Almacenamiento*: Para análisis históricos o depuración, Esper puede almacenar eventos procesados y eventos complejos en una capa de almacenamiento persistente.

=== Databricks

Databricks es una plataforma de análisis abierta y unificada diseñada para construir, implementar, compartir y mantener soluciones de datos, análisis e inteligencia artificial de nivel empresarial a escala. Se integra perfectamente con el almacenamiento en la nube y la seguridad en su cuenta en la nube, administrando e implementando la infraestructura en la nube en su nombre. Databricks se destaca particularmente por su capacidad de conectar varias fuentes de datos a una única plataforma, lo que facilita el procesamiento, almacenamiento, uso compartido, análisis, modelado y monetización de conjuntos de datos. Esta plataforma es versátil, admite una amplia gama de tareas de datos, incluida la programación y administración del procesamiento de datos, la generación de paneles y visualizaciones, la administración de la seguridad y el gobierno, y el soporte para soluciones de aprendizaje automático e inteligencia artificial generativa. @databricks

La plataforma está construida sobre Apache Spark, optimizada para entornos en la nube y ofrece escalabilidad para trabajos a pequeña y gran escala. Admite múltiples lenguajes de codificación a través de una interfaz de cuaderno, lo que permite a los desarrolladores construir algoritmos utilizando Python, R, Scala o SQL. Databricks mejora la productividad al permitir la implementación instantánea de cuadernos en producción y proporciona un entorno colaborativo para científicos de datos, ingenieros y analistas de negocios. También garantiza la confiabilidad y escalabilidad de los datos a través de Delta Lake y admite varios marcos de trabajo, bibliotecas, lenguajes de scripting, herramientas e IDE.

Databricks se destaca por su flexibilidad en diferentes ecosistemas, incluidos AWS, GCP y Azure, y su compromiso con la confiabilidad y escalabilidad de los datos. Admite una amplia gama de marcos y bibliotecas, ofrece gestión del ciclo de vida del modelo a través de MLFlow y permite el ajuste de hiperparámetros con Hyperopt. Además, Databricks se integra con GitHub y Bitbucket, lo que mejora aún más sus capacidades de colaboración. La plataforma es reconocida por su velocidad, y se informa que es 10 veces más rápida que otras soluciones ETL, y proporciona visualizaciones básicas integradas para ayudar en la interpretación de datos.

=== Ingestión nativa en la nube

Las tecnologías de ingesta nativa de la nube han evolucionado significativamente a lo largo de los años, impulsadas por la necesidad de procesamiento y análisis de datos en tiempo real en diversas industrias. A la vanguardia de esta evolución se encuentran Amazon Kinesis, Google Cloud Pub/Sub y Azure Event Hubs, cada uno de los cuales ofrece capacidades únicas adaptadas a diferentes entornos de nube y casos de uso.

Amazon Kinesis se destaca por su completo conjunto de servicios de transmisión de datos en tiempo real, diseñados para manejar todo, desde transmisiones de video en vivo hasta archivos de registro. Su fortaleza radica en su capacidad para ingerir, procesar y analizar datos en streaming en tiempo real, lo que lo hace ideal para aplicaciones que van desde análisis en tiempo real hasta aprendizaje automático. Kinesis está profundamente integrado con otros servicios de AWS, lo que facilita la creación de canalizaciones de procesamiento de datos de un extremo a otro. Su escalabilidad, rendimiento y sólidas funciones de seguridad lo convierten en la opción preferida para las empresas que invierten mucho en el ecosistema de AWS. @kinesis

Google Cloud Pub/Sub es un servicio de mensajería que sobresale en escenarios que requieren arquitecturas basadas en eventos en tiempo real. Admite la ingesta de datos de alto rendimiento y baja latencia, lo que lo hace adecuado para una amplia gama de aplicaciones, desde sistemas de chat y mensajería hasta telemetría de dispositivos IoT. La integración de Pub/Sub con otros servicios de Google Cloud, como Cloud Dataflow para la transformación de datos y Cloud Functions para los cálculos activados por eventos, mejora su versatilidad. Su escalabilidad y confiabilidad, respaldadas por un SLA sólido, lo posicionan como una opción confiable para construir sistemas resilientes de procesamiento de datos en tiempo real. @gcp-pubsub

Azure Event Hubs sirve como un centro central para canalizaciones de big data, capaz de recibir y procesar millones de eventos por segundo. Es particularmente adecuado para soluciones de IoT, donde puede agregar datos de numerosos dispositivos antes de enrutarlos a servicios de almacenamiento o análisis. La integración de Azure Event Hubs con los servicios de Azure, como Azure Stream Analytics para análisis en tiempo real y Azure Machine Learning para modelado predictivo, lo convierte en una herramienta poderosa para desarrollar aplicaciones sofisticadas basadas en datos. Sus características de escalabilidad, rendimiento y seguridad satisfacen las demandas de las aplicaciones modernas centradas en la nube. @azure-event-hub

=== Microsoft Fabric

Microsoft Fabric es una plataforma de análisis y datos innovadora e integral diseñada para abordar las necesidades integrales de las empresas que buscan una solución unificada para el movimiento, procesamiento, ingesta, transformación, enrutamiento de eventos en tiempo real y creación de informes de datos. Consolida una variedad de servicios, que incluyen Ingeniería de Datos, Fábrica de Datos, Ciencia de Datos, Análisis en Tiempo Real, Almacén de Datos y Bases de Datos, en una plataforma única e integrada a la perfección. Esta integración elimina la necesidad de ensamblar servicios de múltiples proveedores, ofreciendo en su lugar una plataforma fácil de usar que simplifica los requisitos de análisis. Al operar en un modelo de Software como Servicio (SaaS), Fabric aporta simplicidad e integración a las soluciones de análisis, aprovechando OneLake para el almacenamiento centralizado de datos e integrando capacidades de IA para mejorar el procesamiento de datos y la generación de conocimientos. @fabric

La arquitectura de Fabric está diseñada para fomentar un ecosistema altamente integrado de servicios de análisis, promoviendo un flujo de datos fluido entre las diferentes etapas de la canalización de análisis. Esta integración reduce los silos de datos y mejora la eficiencia, permitiendo a las empresas utilizar sus herramientas de análisis preferidas mientras mantienen los datos en su ubicación actual. Como plataforma SaaS, Fabric se encarga de la configuración y el mantenimiento de la infraestructura, lo que permite a las organizaciones centrarse en aprovechar sus capacidades analíticas en lugar de administrar la infraestructura subyacente. Está diseñado para escalar sin esfuerzo para adaptarse a cargas de trabajo variables, asegurando que las empresas puedan manejar de manera eficiente grandes volúmenes de datos y tareas analíticas sin experimentar cuellos de botella de rendimiento.

Una de las principales ventajas de Microsoft Fabric es su completo conjunto de análisis, que cubre todo, desde el movimiento de datos hasta la ciencia de datos, el análisis en tiempo real y la inteligencia empresarial. Esta solución integral simplifica el flujo de trabajo de análisis al eliminar la necesidad de invertir y administrar múltiples herramientas dispares. Además, Fabric ofrece capacidades avanzadas de ciencia de datos, proporcionando herramientas y recursos para que los científicos de datos realicen análisis de datos complejos, creen modelos de aprendizaje automático y obtengan información predictiva. Esto respalda la innovación y la optimización basadas en datos, lo que convierte a Fabric en una opción atractiva para las empresas que buscan optimizar sus procesos de análisis y optimizar la toma de decisiones basada en datos.

Finalmente, Fabric se destaca por su interfaz fácil de usar, lo que la hace accesible tanto para empleados técnicos como no técnicos. Esta democratización del análisis de datos en todos los equipos, combinada con sólidas protecciones de seguridad y certificaciones de cumplimiento, posiciona a Fabric como una solución segura, compatible y rentable para las empresas. La capacidad de la plataforma para conectarse a las ofertas PaaS existentes y permitir a los clientes actualizarse a su propio ritmo indica su compatibilidad con las estrategias de análisis en evolución, marcando una evolución de las soluciones de análisis de Microsoft hacia una oferta SaaS simplificada y unificada.

=== Resumen

Esta tabla proporciona una vista general de cómo cada tecnología encaja en el panorama del procesamiento y almacenamiento de big data. Es importante tener en cuenta que las capacidades de estas tecnologías pueden variar significativamente según la versión específica, la configuración y el caso de uso. Además, muchas de estas tecnologías se pueden combinar o ampliar con otras herramientas para lograr requisitos más complejos o especializados. @compendium

#table(
  columns: (1.4fr, 0.8fr, 1fr, 1fr, 1fr),
  align: center,
  table.header(
    [*Tech*], [*Batch*], [*Stream*], [*Storage*], [*Scalable*],
  ),
    [*Hadoop*], [Yes], [No], [Yes (HDFS)], [High],
    [*Kafka*], [Yes], [Yes], [Yes (Kafka Cluster)], [Very High],
    [*Storm*], [No], [Yes], [No], [High],
    [*Spark*], [Yes], [Yes], [Yes], [Very High],
    [*Flink*], [Yes], [Yes], [No], [High],
    [*Flume*], [Yes], [No], [Yes (Avro Sink)], [Medium],
    [*Cassandra*], [Yes], [No], [Yes], [High],
    [*MongoDB*], [Yes], [No], [Yes], [High],
    [*Esper*], [No], [Yes], [No], [Medium],
    [*Databricks*], [Yes], [Yes], [No], [High],
    [*Microsoft Fabric*], [Yes], [Yes], [Yes], [High],
    [*AWS Kinesis*], [Yes], [Yes], [No], [High],
    [*Azure Event Hubs*], [Yes], [Yes], [No], [High],
    [*GCP Pub/Sub*], [Yes], [Yes], [No], [High],
)

== Profundizando en la arquitectura

=== Arquitectura Lambda

La arquitectura Lambda es un marco de procesamiento de datos diseñado para manejar grandes volúmenes de datos de manera eficiente al combinar técnicas de procesamiento por lotes y procesamiento de flujos en tiempo real. Este enfoque híbrido tiene como objetivo abordar los desafíos asociados con el procesamiento de big data al proporcionar un sistema escalable, tolerante a fallas y de baja latencia capaz de analizar datos históricos y en tiempo real. Como es habitual con la transmisión de datos en tiempo real, los datos de entrada vienen en forma de Apache Kafka (en general), debido a su baja latencia y alto rendimiento. @marz @compendium @fundamentals-lambda-kappa

#figure(
    image("images/lambda.png"),
    caption: [
        Lambda Architecture
    ]
)

En esencia, la Arquitectura Lambda consta de tres capas principales:

1. *Capa de Batch*: Esta capa procesa grandes volúmenes de datos históricos en lotes. Almacena los datos de forma inmutable y de solo anexos, lo que garantiza un registro histórico confiable. En esta capa, comúnmente se utilizan tecnologías como Apache Hadoop para la ingesta y el almacenamiento de datos.

2. *Capa de Velocidad*: También conocida como la capa de procesamiento en tiempo real o por streaming, se encarga de procesar los datos nuevos y entrantes casi en tiempo real. Esta capa complementa la capa de batch al reducir la latencia en el acceso a los datos para su análisis. Aquí se suelen emplear motores de procesamiento de streams como Apache Storm, Hazelcast Jet, Apache Flink y Apache Spark Streaming.

3. *Capa de Servicio*: Esta capa es responsable de hacer que los datos procesados sean accesibles para consultas. Indexa incrementalmente las vistas de batch más recientes y los datos más recientes de la capa de velocidad, lo que permite a los usuarios consultar datos tanto históricos como en tiempo real. La capa de servicio también puede reindexar los datos para adaptarse a los cambios en los requisitos o para solucionar problemas. El almacenamiento también se maneja en esta capa, siendo lo más común utilizar Apache Cassandra.

La arquitectura está diseñada para equilibrar varios aspectos críticos del procesamiento de datos, incluida la latencia, el rendimiento y la tolerancia a fallas. Al aprovechar el procesamiento por lotes para un análisis integral de datos y el procesamiento de flujos en tiempo real para obtener información inmediata, la Arquitectura Lambda permite a las organizaciones responder a las oportunidades y desafíos basados en datos de manera más eficaz.

Una de las ventajas clave de la Arquitectura Lambda es su capacidad para manejar grandes volúmenes de datos de diversas fuentes, lo que la hace adecuada para aplicaciones que van desde análisis de comercio electrónico hasta transacciones bancarias y más. Sin embargo, cabe destacar que la implementación de la Arquitectura Lambda puede ser compleja debido a la necesidad de administrar pipelines separados y garantizar la sincronización entre ellos.

En general, la Arquitectura Lambda representa una poderosa solución para las organizaciones que buscan aprovechar el big data y el análisis en tiempo real, ofreciendo una combinación de profundidad histórica y capacidad de respuesta en tiempo real que es esencial para la ventaja competitiva en el mundo actual impulsado por los datos.

=== Arquitectura Kappa

La Arquitectura Kappa, introducida por Jay Kreps, cofundador de Confluent, representa un cambio significativo con respecto a las arquitecturas de procesamiento por lotes tradicionales hacia el procesamiento de datos en tiempo real. Simplifica el flujo de procesamiento de datos al centrarse exclusivamente en procesar datos en tiempo real, eliminando la necesidad de rutas separadas de procesamiento por lotes y en tiempo real que se encuentran en la Arquitectura Lambda. Esta arquitectura se centra en el concepto de un registro de datos inmutable, donde todos los datos (históricos y en tiempo real) se ingestan y almacenan en un registro centralizado, sirviendo como la única fuente de verdad para el procesamiento y análisis continuo de flujos de datos. @compendium @fundamentals-lambda-kappa

#figure(
    image("images/kappa.png"),
    caption: [
        Kappa Architecture
    ]
)

==== Componentes Centrales de la Arquitectura Kappa

- *Registro de Datos Inmutable*: El núcleo de la Arquitectura Kappa es la idea de que todos los datos se tratan como una secuencia ilimitada de eventos. Este enfoque garantiza que los datos estén continuamente disponibles para su procesamiento y análisis, independientemente de cuándo se hayan generado.

- *Ingestión de Streams*: Los datos de diversas fuentes se ingieren en un sistema de procesamiento de flujos, como Apache Kafka. Kafka juega un papel fundamental en la Arquitectura Kappa al proporcionar una infraestructura escalable y tolerante a fallas para la ingestión, almacenamiento y procesamiento de flujos de datos en tiempo real. Garantiza la durabilidad y confiabilidad de los eventos ingeridos.

- *Procesamiento de Streams*: Una vez ingeridos, los datos se procesan en tiempo real utilizando marcos de procesamiento de flujos como Apache Flink o Apache Spark Streaming. Estos marcos permiten el procesamiento complejo de eventos, agregaciones y transformaciones en los datos en streaming, lo que permite análisis y toma de decisiones en tiempo real.

- *Almacenamiento Persistente*: Después del procesamiento, los eventos se almacenan en un sistema de almacenamiento escalable y tolerante a fallas, como Apache Hadoop Distributed File System (HDFS), Apache Cassandra o almacenamiento de objetos en la nube. Este almacenamiento actúa como un lago de datos para el almacenamiento a largo plazo y el procesamiento por lotes potencial en el futuro, aunque el énfasis sigue estando en el procesamiento en tiempo real.

==== Ventajas de la Arquitectura Kappa

- *Procesamiento en Tiempo Real*: La Arquitectura Kappa permite el procesamiento de datos en tiempo real, lo que permite obtener información y tomar decisiones de forma inmediata. Esto es crucial para aplicaciones que requieren una respuesta rápida a las condiciones cambiantes de los datos.

- *Escalabilidad*: La arquitectura es altamente escalable, capaz de manejar grandes volúmenes de datos en tiempo real. Esta escalabilidad es esencial para soportar el crecimiento del volumen de datos y el aumento de la base de usuarios.

- *Rentabilidad*: Dado que la Arquitectura Kappa no requiere una capa de procesamiento por lotes independiente, puede ser más rentable que la Arquitectura Lambda. Esto se debe a que aprovecha una única pila tecnológica para cargas de trabajo de procesamiento en tiempo real y por lotes.

- *Simplicidad*: La arquitectura es más simple que la Arquitectura Lambda, eliminando la complejidad asociada con el mantenimiento de sistemas separados para el procesamiento por lotes y en tiempo real. Esta simplicidad reduce los gastos operativos y aumenta la capacidad de mantenimiento.


=== StreamCube

La arquitectura StreamCube está diseñada para facilitar el análisis en línea, multidimensional y multinivel de datos en streaming, abordando los desafíos que plantean los volúmenes masivos de datos generados en sistemas de vigilancia en tiempo real, telecomunicaciones y otros entornos dinámicos. Esta arquitectura se basa en varios componentes y principios clave que apuntan al cálculo eficiente y efectivo de cubos de streaming, los cuales son esenciales para descubrir características de alto nivel como tendencias y valores atípicos dentro de los datos. @streamcube

==== Técnicas y Principios Centrales:

- *Modelo de Marco de Tiempo Inclinado*: Este modelo introduce un enfoque de resolución múltiple para el registro de datos relacionados con el tiempo. Los datos recientes se registran con resoluciones más finas, lo que permite un análisis más granular, mientras que los datos más antiguos se registran con resoluciones más gruesas, lo que reduce los requisitos generales de almacenamiento y se alinea con las tareas comunes de análisis de datos.

- *Capas Críticas y Capa de Observación*: En lugar de materializar cuboides en todos los niveles, la arquitectura mantiene un número limitado de capas críticas. Este enfoque permite un análisis flexible basado en la capa de observación y conceptos mínimos de capas interesantes, optimizando los recursos del sistema para una ejecución eficiente de consultas.

- *Algoritmo de Camino Popular*: La arquitectura emplea un algoritmo de cubificación de datos de flujo eficiente que calcula solo las capas (cuboides) a lo largo de una ruta popular, dejando otros cuboides para el cálculo en línea impulsado por consultas. Este método permite la construcción y el mantenimiento de cubos de datos de flujo de manera incremental con una cantidad razonable de memoria, costo de cómputo y tiempo de respuesta a las consultas.

==== Desafíos Abordados:

- *Cómputo Paralelo Basado en Memoria Distribuida*: Si bien muchos marcos han abordado este desafío, StreamCube extiende sus capacidades para garantizar un cómputo paralelo eficiente en sistemas distribuidos.

- *Cómputo Redundante y Cálculo Incremental Sobre Grandes Cantidades de Datos Históricos*: Al eliminar la redundancia y agrupar los datos del flujo en diferentes nodos, StreamCube aborda el problema del cómputo redundante causado por los cambios de ventana de tiempo de diferentes consultas. También aborda la dificultad del cálculo incremental sobre grandes cantidades de datos históricos, lo que permite el cálculo en tiempo real de métricas estadísticas complejas.

- *Descomposición de la Lógica Compleja*: StreamCube descompone el cálculo de lógica compleja en un esquema incremental, facilitando el cómputo en tiempo real. Este enfoque permite la implementación del cálculo en tiempo real de varias métricas estadísticas complejas, como varianza, desviación estándar, covarianza y momento central de orden K, entre otras.

- *Detección de Secuencias de Eventos*: StreamCube enfrenta el desafío de detectar secuencias de eventos basadas en datos de flujo, especialmente aquellos que ocurren en múltiples dimensiones o basados en el contexto. Aborda esto proporcionando una tecnología de procesamiento rápido de datos dinámicos basada en el esquema de cálculo incremental, que permite la detección de secuencias de eventos definidas por el usuario.


=== Una arquitectura novedosa

Además de las arquitecturas mencionadas, existe un patrón de arquitectura emergente que consiste en ver cada proceso en una canalización ETL como un microservicio. Una arquitectura de microservicios es un patrón de diseño en el que una aplicación o sistema grande se compone de varios fragmentos diferentes, cada uno responsable de una y solo una tarea. Esto aprovecha perfectamente la responsabilidad única de los principios SOLID y hace que la base de código sea más fácil de desarrollar y mantener para un equipo grande. @big-archive

En la fuente @microservices, el equipo cubre cómo implementaron dicho diseño para un caso de uso de puertos inteligentes y monitoreo de la calidad del aire y mostró resultados impresionantes.

#figure(
    image("images/microservices.png"),
    caption: [
        Microservices Architecture
    ]
)

_Adendo: El diseño implementado no es exactamente igual al del diagrama, ya que los servicios utilizados no emplean las mismas tecnologías sino tecnologías equivalentes. Sin embargo, la idea central es la misma._

Básicamente, lo que lograron fue dividir el proceso ETL en varias capas: Capa de Fuente de Datos, Capa de Filtrado, Capa de Procesamiento y Capa de Servicio, cada una manejando sus respectivas tareas y posiblemente descomponiéndose en varios microservicios, uno por cada subtarea.

== Conclusión

Este es un panorama general de las tecnologías y arquitecturas actuales que la mayoría de los profesionales de datos utilizan para el procesamiento de datos en tiempo real. Elegir la opción correcta para el trabajo puede variar debido a diferentes factores como la disponibilidad en su región, las capacidades de su equipo o su caso de uso específico. Aquí no existe una solución universal.


#bibliography(
    "biblio.yaml",
    title: "References"
)

