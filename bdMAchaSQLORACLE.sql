-- Eliminar las tablas en el orden correcto para evitar errores de dependencia
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE detalle_venta CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ventas CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE productos CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE categorias CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE pagos CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE citas CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE usuario CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignorar errores si las tablas no existen
END;
/

CREATE TABLE usuario (
    id_usuario NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    tipoDeDocumento VARCHAR2(50) CHECK (tipoDeDocumento IN ('dni', 'cne')),
    numeroDeDocumento VARCHAR2(20),
    nombre VARCHAR2(100) NOT NULL,
    apellido VARCHAR2(100) NOT NULL,
    celular VARCHAR2(9) CHECK (celular LIKE '9%' AND LENGTH(celular) = 9),
    email VARCHAR2(100) UNIQUE,
    password VARCHAR2(100),
    rol VARCHAR2(50) CHECK (rol IN ('cliente', 'admin', 'barbero')),
    activo NUMBER(1) DEFAULT 1,
    CONSTRAINT CK_NumeroDeDocumento CHECK (
        (tipoDeDocumento = 'dni' AND LENGTH(numeroDeDocumento) = 8) OR
        (tipoDeDocumento = 'cne' AND LENGTH(numeroDeDocumento) BETWEEN 9 AND 20)
    )
);

-- DROP SEQUENCE usuario_seq;

-- CREATE SEQUENCE usuario_seq START WITH 1 INCREMENT BY 1;


DESCRIBE usuario;


CREATE TABLE citas (
    id_cita NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    fecha DATE NOT NULL,
    hora VARCHAR2(8) NOT NULL, -- Almacenar la hora como una cadena en formato 'HH24:MI'
    nota VARCHAR2(100),
    estado VARCHAR2(50) CHECK (estado IN ('pendiente', 'cancelado', 'terminado')),
    id_cliente NUMBER NOT NULL,
    id_barbero NUMBER NOT NULL, 
    CONSTRAINT fk_cita_cliente FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario),
    CONSTRAINT fk_cita_barbero FOREIGN KEY (id_barbero) REFERENCES usuario(id_usuario)
);

select * from citas;
select * from usuario;

CREATE TABLE pagos (
    id_pago NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    id_cita NUMBER NOT NULL,
    corte_realizado VARCHAR2(100) NOT NULL,
    monto NUMBER(10, 2) NOT NULL CHECK (monto > 0),
    fecha_pago DATE NOT NULL,
    hora_pago VARCHAR2(8) NOT NULL, -- Almacenar la hora del pago como una cadena en formato 'HH24:MI'
    status NUMBER(1) DEFAULT 1,
    CONSTRAINT fk_pago_cita FOREIGN KEY (id_cita) REFERENCES citas(id_cita)
);


CREATE TABLE categorias (
    id_categoria NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE
);


select * from categorias;


INSERT INTO categorias (nombre) VALUES ('cabello');
INSERT INTO categorias (nombre) VALUES ('maquina');
INSERT INTO categorias (nombre) VALUES ('locion');
INSERT INTO categorias (nombre) VALUES ('accesorio');


CREATE TABLE productos (
    id_producto NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    imagen VARCHAR2(255),
    nombre VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(4000),
    precio NUMBER(10, 2) NOT NULL CHECK (precio > 0),
    id_categoria NUMBER NOT NULL,
    estado NUMBER(1) DEFAULT 1,
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

select * from productos;
select * from categorias;


CREATE TABLE ventas (
    id_venta NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    id_usuario NUMBER,
    fecha_venta DATE,
    monto_total NUMBER(10, 2),
    CONSTRAINT fk_ventas_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);



CREATE TABLE detalle_venta (
    id_detalle_venta NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    id_venta NUMBER,
    id_producto NUMBER,
    cantidad NUMBER(10, 2),
    precio_unitario NUMBER(10, 2),
    subtotal NUMBER(10, 2),
    CONSTRAINT fk_detalle_venta_venta FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    CONSTRAINT fk_detalle_venta_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);


-- Inserción de un cliente
INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol)
VALUES ('dni', '72681115', 'OMAR', 'RIVERA', '900222333', 'omar.rivera@example.com', 'omaromar20983', 'admin');

-- Inserción de un admin
INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol)
VALUES ('cne', '902322345666', 'Ana', 'Gómez', '987654321', 'fafa.aaaa@example.com', 'password456', 'cliente');

-- Inserción de un barbero
INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol)
VALUES ('dni', '90876543', 'richard', 'macha', '900233456', 'macha.barber@example.com', 'macha123', 'barbero');

-- nuevas insercciones 
INSERT INTO usuario (tipoDeDocumento, numeroDeDocumento, nombre, apellido, celular, email, password, rol)
VALUES ('dni', '92929222', 'machahaa', 'macha', '900234765', 'machahahaaq.barber@example.com', 'macha12334', 'barbero');

select * from usuario;

describe usuario;

//  de activo a inactivo
update usuario
set activo = 0
where ID_USUARIO = 26 and activo = 1;

select * from usuario;
// eliminacion logica de usuario

-- 3. Actualizar los campos de nombre y apellido de un registro específico

UPDATE usuario
SET nombre = 'nuevoNombre', apellido = 'nuevoApellido'
WHERE id_usuario = 1;

-- 4. Eliminación lógica de un registro
-- Para realizar una eliminación lógica, cambia el valor del campo activo a 0 (desactivado) o a 1 (activado). Por ejemplo, para desactivar un usuario:

UPDATE usuario
SET activo = 0
WHERE id_usuario = 1;

-- Y para activar el usuario nuevamente:


UPDATE usuario
SET activo = 1
WHERE id_usuario = 1;



SELECT constraint_name, column_name
FROM all_cons_columns
WHERE table_name = 'USUARIO';

SELECT usuario_seq.nextval FROM dual;


select * from usuario;

select * from citas;
-- Inserción de una cita pendiente
INSERT INTO citas (fecha, hora, nota, estado, id_cliente, id_barbero)
VALUES (TO_DATE('2024-08-23', 'YYYY-MM-DD'), '10:00', 'Corte de cabello clasico', 'pendiente', 2, 3);


-- Registrar el pago de la cita
INSERT INTO pagos (id_cita, corte_realizado, monto, fecha_pago, hora_pago)
VALUES (1, 'Corte de cabello clásico', 50.00, TO_DATE('2024-08-23', 'YYYY-MM-DD'), '11:00');


select * from pagos;

-- Inserción de productos
INSERT INTO productos (imagen, nombre, descripcion, precio, id_categoria)
VALUES ('img/cabello.jpg', 'Shampoo', 'Shampoo para cabello seco', 20.00, 1);

INSERT INTO productos (imagen, nombre, descripcion, precio, id_categoria)
VALUES ('img/maquina.jpg', 'Máquina de cortar', 'Máquina de cortar cabello profesional', 150.00, 2);

INSERT INTO productos (imagen, nombre, descripcion, precio, id_categoria)
VALUES ('img/locion.jpg', 'Loción para después del afeitado', 'Loción refrescante', 30.00, 3);

INSERT INTO productos (imagen, nombre, descripcion, precio, id_categoria)
VALUES ('img/accesorio.jpg', 'Peine', 'Peine de bolsillo', 5.00, 4);


select * from usuario;
SELECT * from productos;

-- Inserción de una venta
INSERT INTO ventas (id_usuario, fecha_venta, monto_total)
VALUES (2, TO_DATE('2024-08-23', 'YYYY-MM-DD'), 55.00);

select * from ventas;

-- Inserción del detalle de la venta
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal)
VALUES (1, 1, 1, 20.00, 20.00);  -- Shampoo

INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal)
VALUES (1, 4, 1, 5.00, 5.00);  -- Peine

-- Otra inserción de producto
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal)
VALUES (1, 3, 1, 30.00, 30.00);  -- Loción

select * from detalle_venta;

select * from usuario;


