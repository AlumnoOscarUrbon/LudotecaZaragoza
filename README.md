<div align="center">
  <img src="https://i.postimg.cc/fLWxN7hC/ludoteca-Zaragoza-logo.png" width="350px">
  <h3 align="center">Actividad de Aprendizaje 2ª Evaluación</h3>
  <p align="center">Alumno - Óscar Urbón Risueño</p>
  <p align="center">Programación - Curso 2023-2024</p>
</div>

## Introducción

Este proyecto es una aplicación web para una ludoteca, diseñada para facilitar la gestión de juegos y actividades a través de una interfaz intuitiva. La BBDD usada es MySQL. A continuación se describen las funcionalidades implementadas, tratando de categorizarlas en la tabla de requisitos de la actividad.

## Características del proyecto

### Funcionalidades

#### Dar de alta

- **Juegos**: Los usuarios registrados con el rol `admin` pueden acceder al formulario para crear nuevos juegos desde la sección `view-games.jsp` y pulsando en el botón `añadir juego`.
  - Para que un juego sea validado, debe tener:
    - Nombre.
    - Categoría asignada.
    - Formato de fecha correcto.
- **Actividades**: Los usuarios registrados con el rol `admin` pueden acceder al formulario para crear nuevas actividades desde la sección `view-activity.jsp` y pulsando en el botón `añadir actividad`.
  - Para que una actividad sea validada, debe tener:
    - Nombre.
    - Categoría asignada.
    - Formato de fecha correcto.
    - Formato horario correcto.
    - La fecha de comienzo debe ser futura.
- **Usuarios**: Los usuarios que no han iniciado sesión pueden acceder al formulario para crear un nuevo usuario desde la ventana de `login`, haciendo clic en el texto `regístrate aquí`.
  - Para que un usuario sea validado, debe tener:
    - Nombre.
    - Rol asignado.
    - Formato de fecha correcto.
    - Ser mayor de 18 años.
    - Ingresar un password y que este sea válido.

#### Listado y vista detalle

- **Juegos y actividades**: Es posible acceder a la vista detalle individual de cada elemento haciendo clic en su tarjeta correspondiente del `Index`, o desde su nombre a través de las secciones `Mis Favoritos` y `Mis Inscripciones`. Además, desde esas mismas secciones, Juegos y Actividades pueden ser listados todos sus elementos en vista detalle seleccionados por categoría marcando la opción correspondiente en el desplegable que allí se encuentra.
- **Usuarios**: Un usuario registrado con el rol `user` puede acceder a la vista detalle de sus datos desde `Área Personal/Mis datos`. Un usuario registrado con el rol `admin` puede acceder a un listado de todos los usuarios de la BBDD y a sus vistas detalle, desde `Área Personal/Usuarios`, situado en el `header`.

#### Búsqueda

- En el `header` existe un buscador que es funcional en prácticamente la totalidad del sitio web, a excepción de las secciones de registro de juegos, registro de actividades, y en la vista de usuarios si no se tiene el rol `admin`.
- La búsqueda en las secciones `Juegos` y `Actividades` son adicionales a la visualización por categoría. Ambos filtrados pueden ser eliminados rápidamente al pulsar el botón `Eliminar búsqueda en curso`.
- En `Index`, `Actividades` y `Juegos`, la búsqueda busca coincidencias en los campos de nombre y descripción. En `Favoritos` e `Inscripciones` usa nombre y categoría. En `Usuarios` busca por nombre y rol.

#### Modificar y dar de baja

- Si se está logueado con un usuario de tipo `admin`, es posible acceder a los formularios de modificación de juegos y de actividades desde sus tarjetas de detalle, haciendo clic en el botón `editar`.
- Si se está logueado con un usuario de tipo `admin`, es posible eliminar los juegos y las actividades desde sus tarjetas de detalle, haciendo clic en el botón `eliminar`.
- Los usuarios logueados con el rol `user` pueden modificar sus propios datos desde `Área Personal/Mis Datos`. Si en lugar de `user` es `admin`, también puede modificar los datos de cualquier otro usuario.
- Los usuarios logueados con el rol `user` pueden eliminar su propia cuenta desde `Área Personal/Mis Datos`. Si en lugar de `user` es `admin`, también puede eliminar las cuentas de cualquier otro usuario.

#### Login de usuarios

- Existen 3 niveles de permisos:
  - **Ninguno**: solamente puede visualizar juegos y actividades, y darse de alta como nuevo usuario.
  - **User**: puede visualizar juegos y actividades, apuntarse a actividades, marcar juegos como favoritos, y modificar o borrar su cuenta.
  - **Admin**: además de lo anterior, puede añadir nuevos juegos y actividades, modificar los existentes, eliminarlas, modificar a otros usuarios o borrarlos.

#### Repositorio GitHub

- Se han realizado commits al siguiente repositorio durante todo el desarrollo: [https://github.com/AlumnoOscarUrbon/LudotecaZaragoza](https://github.com/AlumnoOscarUrbon/LudotecaZaragoza)

#### Relaciones

- Los usuarios registrados pueden marcar como favorito un juego desde su vista detalle. También pueden apuntarse a una actividad desde su vista detalle. Los usuarios pueden listar sus favoritos e inscripciones desde las secciones correspondientes de su `Área Personal`. Además, desde la lista de inscripciones, pueden saber cuánto tiempo queda para que comience la actividad.
- Los juegos y actividades hacen referencia a tablas específicas que contienen categorías, y que se usan para filtrar los listados. También se puede buscar por categoría escribiendo el nombre de la categoría en el listado de `Favoritos`.

#### Uso de imágenes

- Los formularios de registro y actualización de juegos y de actividades permiten seleccionar un archivo de tipo imagen que será mostrada en la vista detalle del juego y en su tarjeta del `index`. En caso de no seleccionar ninguna imagen al actualizar un elemento, se mantiene la imagen que tenía previamente. En caso de no seleccionar ninguna imagen al dar de alta un elemento, se utiliza una genérica.

#### Funcionalidad (Ajax)

- Es utilizado ampliamente por toda la web. Algunos ejemplos son: refresco en la paginación del `index`, desaparición de tarjetas cuando son borradas, envío de formularios de alta...

#### Funcionalidad (Paginación)

- En `Index` se muestran los juegos y actividades en grupos de 3 unidades, sin importar el número de registros de la BBDD.
- El número de botones de paginación se adapta a la cantidad de registros que hay, incluso cuando se realiza una búsqueda.
- Los botones de `siguiente` y `anterior` son funcionales, y se deshabilitan cuando no pueden funcionar.

#### Alta, baja y listado de una cuarta tabla

- `SignUp` y `Favorites` son dos tablas cuya información puede ser dada de alta y de baja si un usuario ha iniciado sesión, y hace clic en el botón correspondiente de la vista detalle del juego o la actividad. También puede listarlas en su `Área Personal`, desde las secciones `Mis Favoritos` y `Mis Inscripciones`. Allí puede visualizar su información, dar de baja elementos, y ordenar las listas de mayor a menor o viceversa.

#### Zona privada

- Todos los usuarios registrados disponen de un área donde modificar los datos de su perfil y dar de baja su propio usuario.
- También disponen en su zona privada de listados de sus juegos favoritos y de las actividades a las que están apuntados.

#### Confirmación de borrado

- Cuando se pulsa el botón `eliminar`, ya sea en un usuario, una actividad o en un juego, aparece un pop-up solicitando confirmación.
