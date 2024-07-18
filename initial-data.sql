-- Eliminar tablas si existen
DROP TABLE IF EXISTS SignUps;
DROP TABLE IF EXISTS Activities;
DROP TABLE IF EXISTS ActivitiesCategories;
DROP TABLE IF EXISTS Favorites;
DROP TABLE IF EXISTS Games;
DROP TABLE IF EXISTS GameCategories;
DROP TABLE IF EXISTS Users;

-- Crear tablas
CREATE TABLE Users (
  UserId INT AUTO_INCREMENT PRIMARY KEY,
  Username VARCHAR(50) UNIQUE NOT NULL,
  Email VARCHAR (100) ,
  BirthDate DATE,
  Password VARCHAR(255) NOT NULL,
  Role VARCHAR (10) DEFAULT 'User'
);

CREATE TABLE GameCategories (
  GameCategoryId INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Games (
  GameId INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(50) UNIQUE NOT NULL,
  GameCategoryId INT,
  Description TEXT,
  ReleaseDate DATE,
  Picture VARCHAR(100) DEFAULT 'picture_default.jpg',
  FOREIGN KEY (GameCategoryId) REFERENCES GameCategories(GameCategoryId)
);

CREATE TABLE Favorites (
  FavoriteId INT AUTO_INCREMENT PRIMARY KEY,
  RegDateTime DATETIME DEFAULT CURRENT_TIMESTAMP,
  UserId INT,
  GameId INT,
  FOREIGN KEY (UserId) REFERENCES Users(UserId),
  FOREIGN KEY (GameId) REFERENCES Games(GameId)
);

CREATE TABLE ActivitiesCategories (
  ActivityCategoryId INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Activities (
  ActivityId INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(50) NOT NULL UNIQUE,
  ActivityCategoryId INT,
  Description TEXT,
  ActivityStart DATETIME,
  Picture VARCHAR(100) DEFAULT 'picture_default.jpg',
   FOREIGN KEY (ActivityCategoryId) REFERENCES ActivitiesCategories(ActivityCategoryId)
);

CREATE TABLE SignUps (
  SignUpId INT AUTO_INCREMENT PRIMARY KEY,
  RegDateTime DATETIME DEFAULT CURRENT_TIMESTAMP,
  UserId INT,
  ActivityId INT,
  FOREIGN KEY (UserId) REFERENCES Users(UserId),
  FOREIGN KEY (ActivityId) REFERENCES Activities(ActivityId)
);

-- Insertar datos
INSERT INTO Users (Username, Email, BirthDate, Password, Role) 
VALUES 
    ('admin', 'admin@admin.com', '1990-03-20', 'd033e22ae348aeb5660fc2140aec35850c4da997', 'admin'),
    ('user', 'user@user.com', '1992-10-12', '12dea96fec20593566ab75692c9949596833adc9', 'user'),
    ('oscar', 'oscar@gmail.com', '1989-01-08', '2dff4fc90e2973f54d62e257480de234bc59e2c4', 'user');

INSERT INTO GameCategories (Name) 
VALUES 
    ('Juego de Mesa'),
    ('Videojuego'),
    ('Juguete');

INSERT INTO Games (Name, GameCategoryId, Description, ReleaseDate, Picture) 
VALUES 
    ('Catan', 1, 'Catan es el juego de mesa esencial para reuniones familiares y con amigos. Con reglas sencillas y fáciles de explicar, se convierte en la aventura perfecta para los jugadores sociales.', '2015-02-16', 'cat.jpg'),
    ('Dragon Clans', 1, 'Dragon Clans te permite cumplir tu sueño de tener un dragón como mascota. Cría y entrena dragones para convertirte en el mejor entrenador de todos los tiempos.', '2002-05-03', 'dcl.jpg'),
    ('Escape from New York', 1, 'Sumérgete en la atmósfera icónica de "Rescate en Nueva York" con Escape from New York, inspirado en la película de 1982 del maestro del cine John Carpenter.', '2013-07-28', 'efny.jpg'),
    ('Avión Radiocontrol', 3, 'Vuela alto con este avión radiocontrolado que alcanza velocidades de hasta 50 km/h. Su manejo sencillo te hará sentir como un verdadero piloto.', '2015-02-11', 'ara.jpg'),
    ('Robot Interactivo', 3, 'Descubre las increíbles habilidades del Robot Interactivo, capaz de hablar, jugar al fútbol y más. El compañero perfecto para todas tus fiestas con amigos.', '2022-01-12', 'rin.jpg'),
    ('Fuerte PlayMobil', 3, 'Revive las emocionantes aventuras del Salvaje Oeste con el Fuerte PlayMobil. Perfecto para recrear la lucha entre indios y vaqueros con gran diversión.', '2018-10-12', 'fdp.jpg'),
    ('Assassin\'s Creed Origins', 2, 'En "Assassin\'s Creed Origins", el viajero del tiempo más famoso se embarca en una épica aventura siguiendo el curso del río Nilo. Descubre las sorpresas que te esperan.', '2018-10-12', 'aco.jpg'),
    ('Fifa 2024', 2, 'Experimenta el fútbol como nunca antes con Fifa 2024. Juega con tus jugadores favoritos, disfruta de controles renovados y un modo online que te llevará al límite.', '2018-10-12', 'f24.jpg'),
    ('Fifa 2023', 2, 'El fútbol ha evolucionado en Fifa 2023. Disfruta con tus jugadores favoritos, descubre nuevos controles y enfrenta el increíble modo online. El reto te espera.', '2018-10-12', 'f23.jpg');

INSERT INTO Favorites (RegDateTime, UserId, GameId) 
VALUES 
    ('2015-07-13 10:15:00', 1, 1),
    ('2023-01-11 18:45:00', 1, 3),
    ('2016-04-12 15:30:00', 1, 6),
    ('2020-05-17 11:43:13', 1, 8),
    ('2016-04-12 15:30:00', 2, 3),
    ('2023-01-11 18:45:00', 2, 4),
    ('2021-11-10 09:00:00', 2, 8),
    ('2019-07-13 10:15:00', 3, 1),
    ('2019-07-13 10:15:00', 3, 5),
    ('2021-11-10 09:00:00', 3, 8);
   
INSERT INTO ActivitiesCategories (Name)
VALUES
    ('Interior'),
    ('Exterior');

INSERT INTO Activities (Name, ActivityCategoryId, Description, ActivityStart, Picture)
VALUES
    ('Noche de karaoke', 1, 'Disfruta de una noche llena de diversión cantando tus canciones favoritas con amigos y familia. Una oportunidad única para soltarte y mostrar tu talento en un ambiente amigable y festivo.', '2024-07-20 20:43:00', 'kar.jpg'),
    ('Partido de fútbol', 2, 'Vive la emoción de un partido de fútbol al aire libre, ideal para disfrutar con amigos y demostrar tus habilidades. Únete a la pasión del deporte y siente la energía de la competencia en cada jugada.', '2026-07-21 17:12:00', 'pdf.jpg'),
    ('Batalla de paintball', 2, 'Únete a una intensa batalla de paintball y siente la adrenalina de esta emocionante actividad al aire libre. Perfecta para los amantes de la acción, donde la estrategia y el trabajo en equipo son clave para la victoria.', '2026-01-22 10:30:15', 'bdp.jpg'),
    ('Taller de alfarería', 1, 'Descubre el arte de la alfarería en este taller para todas las edades. Crea tus propias piezas únicas y divertidas mientras aprendes técnicas tradicionales y modernas de esta fascinante disciplina.', '2024-12-23 14:00:00', 'tda.jpg'),
    ('Paseo por el bosque', 2, 'Explora la belleza de la naturaleza con una emocionante caminata por el bosque, perfecta para los amantes de la aventura. Conéctate con el entorno natural, respira aire fresco y disfruta de paisajes impresionantes.', '2024-11-24 09:51:00', 'apeb.jpg'),
    ('Clase de repostería', 1, 'Aprende a preparar deliciosos postres en esta divertida clase de repostería. Ideal para todos los amantes de la cocina, donde podrás mejorar tus habilidades y sorprender a tus seres queridos con dulces creaciones.', '2024-10-25 18:23:00', 'cdr.jpg'),
    ('Vr: paseo internet', 1, 'Colocate unas gafas de realidad virtual y sumergete en un mundo nuevo. El metaverso está lleno de posibilidaes por descubrir, esperando a pioneros como tu. Apuntante ahora! .', '2025-02-13 12:15:00', 'vrp.jpg'),
    ('Paseo en canoa', 2, 'Navega por el río Ebro y disfruta de un increíble día en canoa, aprendiendo nuevas habilidades y apreciando la naturaleza. Una experiencia única para conectarse con el agua y descubrir paisajes escondidos.', '2025-07-26 16:00:00', 'pec.jpg');


INSERT INTO SignUps (RegDateTime, UserId, ActivityId)
VALUES
    ('2020-07-11 12:30:00', 1, 1),
    ('2024-06-15 11:11:54', 1, 2),
    ('2023-07-15 20:00:42', 1, 5),
    ('2022-03-05 12:45:14', 1, 4),
    ('2024-07-15 13:53:05', 2, 2),
    ('2018-06-13 14:43:24', 2, 3),
    ('2024-07-25 05:13:00', 2, 6),
    ('2019-01-15 16:43:45', 3, 1),
    ('2021-07-15 02:12:00', 3, 2),
    ('2024-07-15 18:35:16', 3, 7);
    
   select * from Activities;