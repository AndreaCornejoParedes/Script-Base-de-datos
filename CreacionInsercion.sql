
USE consignacionRACIEMSA;

/*Indice en nombre debido a que probablemente se hagan busquedas por nombre*/
CREATE TABLE Proveedor(
Codigo_proveedor CHAR(10) PRIMARY KEY,
Razon_social VARCHAR(50) UNIQUE NOT NULL,
RUC char(11) NOT NULL
);
CREATE INDEX Nombre ON Proveedor(Razon_social);

CREATE TABLE Direcciones(
Codigo_proveedor CHAR(10) NOT NULL,
Id_direccion CHAR(5) NOT NULL UNIQUE,
Direccion VARCHAR(70) NOT NULL UNIQUE,
PRIMARY KEY (Codigo_proveedor, Id_direccion),
foreign key(Codigo_proveedor) REFERENCES Proveedor(Codigo_proveedor)
);
CREATE TABLE Correos(
Codigo_proveedor CHAR(10) NOT NULL,
Id_correo CHAR(5) NOT NULL UNIQUE,
Correo VARCHAR(30) NOT NULL UNIQUE,
PRIMARY KEY (Codigo_proveedor, Id_correo),
foreign key(Codigo_proveedor) REFERENCES Proveedor(Codigo_proveedor)
);
CREATE TABLE Telefono(
Codigo_proveedor CHAR(10) NOT NULL,
Id_telefono CHAR(5) NOT NULL UNIQUE,
Telefono VARCHAR(12) NOT NULL UNIQUE,
PRIMARY KEY (Codigo_proveedor, Id_telefono),
foreign key(Codigo_proveedor) REFERENCES Proveedor(Codigo_proveedor)
);
CREATE TABLE Catalogo(
ID_Catalogo CHAR(8) PRIMARY KEY,
Ubicacion CHAR(4) UNIQUE NOT NULL
);

/*Indice en el nombre debido a que es mas probable buscar los
materiales por su nombre*/
CREATE TABLE Material(
Numero_de_parte CHAR(10) PRIMARY KEY,
Descripcion VARCHAR(80) UNIQUE NOT NULL,
Unidad_de_medida VARCHAR(3) NOT NULL,
ID_Catalogo CHAR(8) NOT NULL,
Stock INT NOT NULL,
Codigo_sap CHAR(7) UNIQUE NOT NULL,
Total FLOAT(5,2) NOT NULL,
Cotizacion FLOAT(5,2) NOT NULL,
foreign key(ID_Catalogo) REFERENCES Catalogo(ID_Catalogo)
);
CREATE INDEX NombreMaterial ON Material(Descripcion);
CREATE INDEX SAP ON Material(Codigo_sap);

CREATE TABLE Ubicaciones(
Numero_de_parte CHAR(10) UNIQUE NOT NULL,
Anaquel CHAR(2) NOT NULL,
Parte_anaquel CHAR(1) NOT NULL,
Piso CHAR(2) NOT NULL,
Particion CHAR(1) NOT NULL,
PRIMARY KEY (Numero_de_parte,Anaquel),
foreign key(Numero_de_parte) REFERENCES Material(Numero_de_parte)
);
CREATE TABLE Guia_de_remision(
Codigo_guia_remision CHAR(14) PRIMARY KEY,
Fecha_de_emision DATE NOT NULL,
Inicio_traslado DATE NOT NULL,
Fin_traslado DATE NOT NULL,
Codigo_proveedor CHAR(10) NOT NULL,
foreign key(Codigo_proveedor) REFERENCES Proveedor(Codigo_proveedor)
);

/*Debido a que es probable que se desee obtener los vales
mas recienter*/
CREATE TABLE Vale_de_entrada(
ID_vale_entrada CHAR(8) PRIMARY KEY,
Codigo_guia_remision CHAR(14),
Hora TIME NOT NULL,
Fecha_recepcion DATE UNIQUE NOT NULL,
foreign key(Codigo_guia_remision) REFERENCES Guia_de_remision(Codigo_guia_remision)
);
CREATE INDEX  Fecha ON Vale_de_entrada(Fecha_recepcion);

CREATE TABLE Entradas(
ID_vale_entrada CHAR(8) NOT NULL,
Numero_de_parte CHAR(10) NOT NULL,
Cantidad_recibida INT NOT NULL,
Observacion VARCHAR(100),
Status tinyint(1) NOT NULL,
PRIMARY KEY (ID_vale_entrada, Numero_de_parte),
foreign key(ID_vale_entrada) REFERENCES Vale_de_entrada(ID_vale_entrada),
foreign key(Numero_de_parte) REFERENCES Material(Numero_de_parte)
);
CREATE INDEX  Parte ON Entradas(Numero_de_parte);

 /*Debido a que es necesario tener las solicitudes mas recientes*/
CREATE TABLE Solicitud_de_reposicion(
Codigo_reposicion CHAR(6) PRIMARY KEY,
Codigo_proveedor CHAR(10) NOT NULL,
Fecha_solicitud DATE NOT NULL,
foreign key(Codigo_proveedor) REFERENCES Proveedor(Codigo_proveedor)
);
CREATE INDEX  Fecha ON Solicitud_de_reposicion(Fecha_solicitud);

CREATE TABLE Solicitud_de_correccion(
Codigo_solicitud_correccion CHAR(8) PRIMARY KEY,
Codigo_reposicion CHAR(6) UNIQUE NOT NULL,
Codigo_guia_remision CHAR(14) UNIQUE NOT NULL,
Motivo VARCHAR(55) NOT NULL,
Fecha DATE NOT NULL,
foreign key(Codigo_reposicion) REFERENCES Solicitud_de_reposicion(Codigo_reposicion),
foreign key(Codigo_guia_remision) REFERENCES Guia_de_remision(Codigo_guia_remision)
);
CREATE TABLE Correcciones(
Codigo_solicitud_correccion CHAR(8),
Numero_de_parte CHAR(10),
Diferencia INT NOT NULL,
PRIMARY KEY(Codigo_solicitud_correccion, Numero_de_parte),
foreign key(Codigo_solicitud_correccion) REFERENCES Solicitud_de_correccion(Codigo_solicitud_correccion),
foreign key(Numero_de_parte) REFERENCES Material(Numero_de_parte)
);
CREATE TABLE Solicitados(
Numero_de_parte CHAR(10) NOT NULL,
Codigo_reposicion CHAR(6) NOT NULL,
Cantidad_solicitada INT NOT NULL,
Prioridad TINYINT(1) NOT NULL,
Observaciones VARCHAR(100),
PRIMARY KEY(Numero_de_parte, Codigo_reposicion),
foreign key(Numero_de_parte) REFERENCES Material(Numero_de_parte),
foreign key(Codigo_reposicion) REFERENCES Solicitud_de_reposicion(Codigo_reposicion)
);
CREATE INDEX  Parte ON Solicitados(Numero_de_parte);


/* Insercion de datos de proveeodr y sus datos de contacto */
INSERT INTO proveedor VALUES ("2060018016", "Automotriz Andina S.A.","20100201396");
INSERT INTO proveedor VALUES ("2060018017", "Distribuidora Cummins Per?? SAC.","20543725821");
INSERT INTO direcciones VALUES ("2060018016", "D0140","Av. Parra Nro. 122 Vallecito Arequipa Peru");
INSERT INTO direcciones VALUES ("2060018017", "D0141","Av. Argentina Nro. 4453 Callao Lima Peru");
INSERT INTO telefono VALUES ("2060018016", "T0284","201633");
INSERT INTO telefono VALUES ("2060018016", "T0285","222200");
INSERT INTO telefono VALUES ("2060018016", "T0286","229327");
INSERT INTO telefono VALUES ("2060018016", "T0287","229345");
INSERT INTO telefono VALUES ("2060018016", "T0288","608474");
INSERT INTO telefono VALUES ("2060018017", "T0289","6147979");
INSERT INTO correos VALUES ("2060018016", "C0140","fatkey.phang@mail.altrisa.com");
INSERT INTO correos VALUES ("2060018017", "C0141","marcial.cuba@cumminsperu.pe");

/* Insercion de guias de remision */
INSERT INTO guia_de_remision VALUES ("GR.402-0016669", "2021-03-20","2021-03-21","2021-04-04","2060018017");
INSERT INTO guia_de_remision VALUES ("GR.402-0016670", "2021-04-17","2021-04-18","2021-05-01","2060018016");
INSERT INTO guia_de_remision VALUES ("GR.402-0016671", "2021-05-23","2021-05-24","2021-06-07","2060018017");
INSERT INTO guia_de_remision VALUES ("GR.402-0016672", "2021-06-18","2021-06-19","2021-07-02","2060018017");
INSERT INTO guia_de_remision VALUES ("GR.402-0016673", "2021-07-21","2021-07-22","2021-08-05","2060018016");

/* Insercion de catalogos */
INSERT INTO catalogo VALUES ("ABC47514", "2018");

/* Insercion de materiales */
INSERT INTO material VALUES ("1022480372", "FILTRO COMBUSTIBLE 20976003/22480372","UND","ABC47514",31,"5533823",974.85,64.99);
INSERT INTO material VALUES ("1021707134", "FILTRO ACEITE VOLVO 466634 / 21707134","UND","ABC47514",68,"5000754",418.5,139.50);
INSERT INTO material VALUES ("1018159975", "FILTRO SEPARADOR AGUA VOLVO - 8159975","UND","ABC47514",54,"5502128",637.6,318.80);
INSERT INTO material VALUES ("1010349619", "FILTRO HIDROLINA R - VOLVO - 349619","UND","ABC47514",19,"5000831",0,0);
INSERT INTO material VALUES ("1020532237", "FILTRO AGUA 1699830 (20532237) VOLVO","UND","ABC47514",8,"5501725",0,0);
INSERT INTO material VALUES ("1161280", "ACEITE CAJA MANUAL 1161280","L","ABC47514", 624,"6503592", 707.178,1.78);
INSERT INTO material VALUES ("21834199", "FILTRO AIRE PRIMARIO 21834199 VOLVO","UND","ABC47514", 19,"5566418", 19,0.00);
INSERT INTO material VALUES ("85108901", "ANTICONGELANTE VOLVO - 85108901","L","ABC47514", 420,"6515781", 579.04,8.00);
INSERT INTO material VALUES ("21707132", "FILTRO ACEITE MARCA:VOLVO 21707132","UND","ABC47514", 47,"5101276", 47,0.00);
INSERT INTO material VALUES ("21834210", "FILTRO AIRE VOLVO - 8149961/21834210","UND","ABC47514",12,"5507262", 12,0.00);
INSERT INTO material VALUES ("8193841", "FILTRO PETROLEO FH 420799 / 8193841","UND","ABC47514", 34,"5000850", 35,1.27);
INSERT INTO material VALUES ("20795271", "CONDUCTO vOLVO - 20795271","UND" ,"ABC47514", 3,"5595990", 8,239.21);
INSERT INTO material VALUES ("21380488", "FILTRO SEPARAD. AGUA 20879812 / 21380488","UND","ABC47514", 29,"5561131", 29,0.00);
INSERT INTO material VALUES ("3517857", "FILTRO ACEITE CAJA CAMBIOS VOLVO 3517857","UND","ABC47514", 0,"5000772", 8,19.70);
INSERT INTO material VALUES ("21938497", "FILTRO AGUA MACK - 21938497","UND","ABC47514", 3,"5547834", 3,0.0);
INSERT INTO material VALUES ("2020N30", "PREFILTRO COMBUST. 7005-2020N30  MACK","UND","ABC47514", 3,"5547838", 3,0.0);
INSERT INTO material VALUES ("20760515", "ANILLO ACOPLE VOLVO - 20760515","UND","ABC47514", 8,"5607576", 8,0.0);
INSERT INTO material VALUES ("3406905", "MANGUERA FLEXIBLE CUMMINS 3406905","UND","ABC47514", 3,"5589294", 3,153.97);
INSERT INTO material VALUES ("ZBH995568", "JGO REPARACION EMBRAGUE VENTILADOR 7600 HORTON","JGO","ABC47514", 0,"5614734", 0,0.0);
INSERT INTO material VALUES ("2591432C91", "KIT TANQUES RADIADOR 7600 - 2591432C91","UND","ABC47514", 3,"5585760", 3,780.64);
INSERT INTO material VALUES ("2592442C91", "JGO DE SELLOS  CAJA DIR M110","KT","ABC47514", 1,"5579318", 1,624.40);
INSERT INTO material VALUES ("3607384C1", "RELAY 12 VOLT.   (5pat) 896H1CHCR1U24","UND","ABC47514", 8,"5637390", 8,23.38);
INSERT INTO material VALUES ("275707BXW", "GOBERNADOR  AIRE 410986C92 (275707BXW)","UND","ABC47514", 5,"5600666", 5,158.82);
INSERT INTO material VALUES ("2882146", "KIT DE REPARACION BB AGUA CUMMINS 4955802","KT","ABC47514", 5,"5637242", 5,573.05);
INSERT INTO material VALUES ("1661281C91", "FARO POSTERIOR LH  2 CONEC 7600 VER 4054545C91","UND","ABC47514", 0,"5526577", 0,0.0);

/* Insercion de vales de entrada */
INSERT INTO Vale_de_entrada VALUES("81528154", "GR.402-0016669", "10:16:15", "2021-04-30");
INSERT INTO Vale_de_entrada VALUES("48512657", "GR.402-0016670", "09:30:40", "2021-05-30");
INSERT INTO Vale_de_entrada VALUES("48714195", "GR.402-0016671", "11:25:20", "2021-06-30");
INSERT INTO Vale_de_entrada VALUES("13524871", "GR.402-0016672", "12:40:02", "2021-07-30");
INSERT INTO Vale_de_entrada VALUES("98574126", "GR.402-0016673", "04:20:55", "2021-08-30");


/* Insercion de solicitudes de reposicion */
INSERT INTO solicitud_de_reposicion VALUES ('R15256',2060018016,'2021-04-05');
INSERT INTO solicitud_de_reposicion VALUES ('R15257',2060018016,'2021-05-04');
INSERT INTO solicitud_de_reposicion VALUES ('R15258',2060018016,'2021-06-06');
INSERT INTO solicitud_de_reposicion VALUES ('R15259',2060018017,'2021-07-03');
INSERT INTO solicitud_de_reposicion VALUES ('R15260',2060018017,'2021-08-02');

/* Insercion de datos de solicitudes de correccion */
INSERT INTO solicitud_de_correccion VALUES ('SC000151','R15256','GR.402-0016669','Faltan unidades','2021-04-04');
INSERT INTO solicitud_de_correccion VALUES ('SC000152','R15257','GR.402-0016670','Faltan unidades','2021-05-01');
INSERT INTO solicitud_de_correccion VALUES ('SC000153','R15258','GR.402-0016671','Faltan unidades','2021-05-01');

INSERT INTO Correcciones VALUES("SC000151", "1161280", 2);
INSERT INTO Correcciones VALUES("SC000152", "21834199", 1);
INSERT INTO Correcciones VALUES("SC000153", "85108901", 1);

/* Insercion de articulos solicitados en las solicitudes de reposicion*/
INSERT INTO solicitados VALUES ("1161280", "R15256", 4, 0, NULL);
INSERT INTO solicitados VALUES ("1020532237", "R15256", 4, 1, NULL);
INSERT INTO solicitados VALUES ("1010349619", "R15256", 10, 1, NULL);
INSERT INTO solicitados VALUES ("1018159975", "R15256", 23, 0, NULL);
INSERT INTO solicitados VALUES ("3406905", "R15256", 10, 1, "Color azul");
INSERT INTO solicitados VALUES ("1022480372", "R15256", 3, 0, NULL);
INSERT INTO solicitados VALUES ("2882146", "R15256", 2, 0, NULL);

INSERT INTO solicitados VALUES ("21380488", "R15257",20 , 0, NULL);
INSERT INTO solicitados VALUES ("20795271", "R15257",2 , 1, NULL);
INSERT INTO solicitados VALUES ("8193841", "R15257",30 , 0, NULL);
INSERT INTO solicitados VALUES ("21834199", "R15257",7 , 0, NULL);
INSERT INTO solicitados VALUES ("85108901", "R15257",20 , 0, NULL);
INSERT INTO solicitados VALUES ("20760515", "R15257",2 , 1, NULL);

INSERT INTO solicitados VALUES ("1021707134", "R15258",8 , 1, NULL);
INSERT INTO solicitados VALUES ("275707BXW", "R15258",1 , 0, NULL);
INSERT INTO solicitados VALUES ("85108901", "R15258",10 , 0, NULL);
INSERT INTO solicitados VALUES ("1661281C91", "R15258",20 , 0, NULL);
INSERT INTO solicitados VALUES ("3607384C1", "R15258",4 , 1, NULL);

INSERT INTO solicitados VALUES ("1022480372", "R15259",25 , 1, NULL);
INSERT INTO solicitados VALUES ("1021707134", "R15259",10 , 0, NULL);
INSERT INTO solicitados VALUES ("1018159975", "R15259",105 , 0, NULL);
INSERT INTO solicitados VALUES ("1010349619", "R15259",10 , 0, NULL);
INSERT INTO solicitados VALUES ("1020532237", "R15259",20 , 1, NULL);

INSERT INTO solicitados VALUES ("ZBH995568", "R15260",34 , 1, NULL);
INSERT INTO solicitados VALUES ("21834199", "R15260",100 , 0, NULL);
INSERT INTO solicitados VALUES ("1661281C91", "R15260",500 , 0, NULL);
INSERT INTO solicitados VALUES ("8193841", "R15260",20 , 0, NULL);
INSERT INTO solicitados VALUES ("21834210", "R15260",12 , 1, NULL);


/* Insercion de articulos que ingresan */
INSERT INTO entradas VALUES("81528154","1161280",4,NULL,1);
INSERT INTO entradas VALUES("81528154","1020532237",4,NULL,1);
INSERT INTO entradas VALUES("81528154","1010349619",10,NULL,1);
INSERT INTO entradas VALUES("81528154","1018159975",23,NULL,1);
INSERT INTO entradas VALUES("81528154","3406905",10,NULL,1);
INSERT INTO entradas VALUES("81528154","1022480372",3,NULL,1);
INSERT INTO entradas VALUES("81528154","2882146",2,NULL,1);

INSERT INTO entradas VALUES("48512657","21380488",20,NULL,1);
INSERT INTO entradas VALUES("48512657","20795271",2,NULL,1);
INSERT INTO entradas VALUES("48512657","8193841",30,NULL,1);
INSERT INTO entradas VALUES("48512657","21834199",7,NULL,1);
INSERT INTO entradas VALUES("48512657","85108901",20,NULL,1);
INSERT INTO entradas VALUES("48512657","20760515",2,NULL,1);

INSERT INTO entradas VALUES("48714195","1021707134",8,NULL,1);
INSERT INTO entradas VALUES("48714195","275707BXW",1,NULL,1);
INSERT INTO entradas VALUES("48714195","85108901",10,NULL,1);
INSERT INTO entradas VALUES("48714195","1661281C91",20,NULL,1);
INSERT INTO entradas VALUES("48714195","3607384C1",4,NULL,1);

INSERT INTO entradas VALUES("13524871","1022480372",25,NULL,1);
INSERT INTO entradas VALUES("13524871","1021707134",10,"Cajas de filtros maltratadas",1);
INSERT INTO entradas VALUES("13524871","1018159975",105,NULL,1);
INSERT INTO entradas VALUES("13524871","1010349619",10,NULL,1);
INSERT INTO entradas VALUES("13524871","1020532237",20,NULL,1);

INSERT INTO entradas VALUES("98574126","ZBH995568",34,NULL,1);
INSERT INTO entradas VALUES("98574126","21834199",100,NULL,1);
INSERT INTO entradas VALUES("98574126","1661281C91",500,NULL,1);
INSERT INTO entradas VALUES("98574126","8193841",20,NULL,1);
INSERT INTO entradas VALUES("98574126","21834210",12,NULL,1);


/* Insercion de ubicaciones de los materiales*/
INSERT INTO Ubicaciones VALUES ("1022480372", "01","A","01","A");
INSERT INTO Ubicaciones VALUES ("1021707134", "01","A","01","B");
INSERT INTO Ubicaciones VALUES ("1018159975", "01","B","02","A");
INSERT INTO Ubicaciones VALUES ("1010349619", "01","B","02","B");
INSERT INTO Ubicaciones VALUES ("1020532237", "01","C","03","A");
INSERT INTO Ubicaciones VALUES ("1161280", "01", "C","03","B");
INSERT INTO Ubicaciones VALUES ("21834199", "01","D","04","A");

INSERT INTO Ubicaciones VALUES ("85108901", "02","A","01","B");
INSERT INTO Ubicaciones VALUES ("21707132", "02","A","01","A");
INSERT INTO Ubicaciones VALUES ("21834210", "02","B","02","B");
INSERT INTO Ubicaciones VALUES ("8193841", "02","B","02","A");
INSERT INTO Ubicaciones VALUES ("20795271", "02","C" ,"03","B");
INSERT INTO Ubicaciones VALUES ("21380488", "02","C","03","A");
INSERT INTO Ubicaciones VALUES ("3517857", "02","D","04","B");
INSERT INTO Ubicaciones VALUES ("21938497","02","D","04","A");

INSERT INTO Ubicaciones VALUES ("2020N30", "03","A","01","B");
INSERT INTO Ubicaciones VALUES ("20760515", "03","A","02","A");
INSERT INTO Ubicaciones VALUES ("3406905", "03","B","02","B");
INSERT INTO Ubicaciones VALUES ("ZBH995568", "03","B","02","A");
INSERT INTO Ubicaciones VALUES ("2591432C91", "03","C","03","B");
INSERT INTO Ubicaciones VALUES ("2592442C91", "03","C","03","A");
INSERT INTO Ubicaciones VALUES ("3607384C1", "03","D","04","B");
INSERT INTO Ubicaciones VALUES ("275707BXW", "03","D","04","A");

INSERT INTO Ubicaciones VALUES ("2882146", "04","A","01","B");
INSERT INTO Ubicaciones VALUES ("1661281C91", "04","A","01","B");