# Nexo Tech · Eventos Tecnológicos

> Una web estática para descubrir eventos, charlas y encuentros relacionados con tecnología, innovación y futuro digital.

## Autor

**Karim Bahli**

## Descripción

Nexo Tech es una página web estática diseñada para presentar eventos tecnológicos de forma clara, moderna y atractiva.

La web incluye:

- Próximos eventos tecnológicos.
- Fechas, horarios y ubicaciones.
- Eventos online y presenciales.
- Sección informativa sobre la comunidad.
- Diseño responsive para ordenador y móvil.
- Despliegue en Amazon S3.

## Tecnologías utilizadas

- HTML5
- CSS3
- Terraform
- AWS S3
- AWS CLI
- Git y GitHub

## Infraestructura

Terraform automatiza:

1. La creación del bucket S3.
2. La configuración del hosting web estático.
3. La configuración de acceso público.
4. La aplicación de la política de lectura.
5. La subida del archivo `index.html`.
6. La generación de la URL pública.

Debido a las restricciones de AWS Academy Learner Lab con Object Lock, el proyecto utiliza `terraform_data` junto con AWS CLI para ejecutar las operaciones de S3 sin realizar llamadas bloqueadas por la política SCP.
