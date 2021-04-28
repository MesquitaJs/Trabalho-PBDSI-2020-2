  		
						/* TRABALHO PROJETO DE BANCO DE DADOS PARA SI 2020.2                                   
									BASE DE DADOS: MySQL                                                    
												                            						
									PARTE 1:                              							
                        																			
				ITEM 4 - Criar usando a linguagem de programação do SGBD escolhido um script que construa
					     de forma dinâmica a partir do catálogo os comandos create table das tabelas
						 existentes no esquema exemplo considerando pelo menos as informações sobre
						 colunas (nome, tipo e obrigatoriedade) e chaves primárias e estrangeiras
						 */
		

			/*Querys usadas para verifcar o conteúdo do catálogo e para aprender a usá-lo:*/					
																									
		 -- consultas na tabela information_schema.TABLE_CONSTRAINTS:
			-- select * from information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = 'chinook';
					
	-- consultas na tabela information_schema.KEY_COLUMN_USAGE:
		-- select * from information_schema.KEY_COLUMN_USAGE WHERE CONSTRAINT_SCHEMA = 'chinook';
		
		-- JOIN entre information_schema.KEY_COLUMN_USAGE E information_schema.TABLE_CONSTRAINTS

			/*
			SELECT tc.TABLE_NAME AS NOME_TABELA,
				kcu.COLUMN_NAME AS NOME_COLUNA,
				tc.CONSTRAINT_NAME AS FOREIGN_KEY,
				kcu.REFERENCED_TABLE_NAME AS NOME_TABELA_REFERENCIADA,
				kcu.REFERENCED_COLUMN_NAME AS NOME_COLUNA_REFERENCIADA
			FROM information_schema.TABLE_CONSTRAINTS tc INNER JOIN information_schema.KEY_COLUMN_USAGE kcu
				ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
			WHERE kcu.CONSTRAINT_SCHEMA = 'chinook'
				AND tc.CONSTRAINT_TYPE = 'FOREIGN KEY' AND  tc.TABLE_SCHEMA = 'chinook';
			*/
		



/*ITEM 4 - resposta: */
USE Chinook;



/* 
	Comando CRIATE TABLE:
	
	Ex.:
	CREATE TABLE `Track`
	(
		`TrackId` INT NOT NULL,
		`Name` NVARCHAR(200) NOT NULL,
		`AlbumId` INT,
		`MediaTypeId` INT NOT NULL,
		`GenreId` INT,
		`Composer` NVARCHAR(220),
		`Milliseconds` INT NOT NULL,
		`Bytes` INT,
		`UnitPrice` NUMERIC(10,2) NOT NULL,
		CONSTRAINT `PK_Track` PRIMARY KEY  (`TrackId`)
	);
*/


SELECT CONCAT( 'CREATE TABLE ', t2.table_name, ' ( ', attrs,
	IF(primary_key IS NOT NULL, CONCAT(', PRIMARY KEY(',  primary_key, ')'), ''), ' );') AS ''

FROM(
		SELECT GROUP_CONCAT(column_name) AS attrs, table_name
		
		FROM(
				SELECT CONCAT(' ', COLUMN_NAME , ' ', DATA_TYPE,
				IF(DATA_TYPE = 'varchar', CONCAT('(',CHARACTER_MAXIMUM_LENGTH, ')'), ''), ' ',
				IF(IS_NULLABLE = 'No', '', 'NOT NULL')) AS column_name, kcu.TABLE_NAME AS table_name
				FROM information_schema.COLUMNS kcu  WHERE kcu.TABLE_SCHEMA = 'Chinook'
					
		    ) AS t1 GROUP BY table_name
				 
    ) AS t2 INNER JOIN (
							SELECT GROUP_CONCAT( COLUMN_NAME) AS primary_key, tc.TABLE_NAME AS table_name
							FROM information_schema.TABLE_CONSTRAINTS tc
							INNER JOIN information_schema.KEY_COLUMN_USAGE kcu
							ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME	AND tc.table_name = kcu.table_name
							WHERE kcu.CONSTRAINT_SCHEMA = 'Chinook' AND
							tc.TABLE_SCHEMA = 'Chinook' AND 
							tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
							GROUP BY tc.table_name
							
						) AS t3 ON t2.table_name = t3.table_name;
            

/*
		COMANDO CREATE FOREIGN KEYS:
			Ex.:
			ALTER TABLE `Track` ADD CONSTRAINT `FK_TrackGenretId`
			FOREIGN KEY (`GenreId`) REFERENCES `Genre` (`GenreId`);
*/
SELECT CONCAT(
				'ALTER TABLE ', tc.TABLE_NAME,
				' ADD CONSTRAINT ',tc.CONSTRAINT_NAME,
				' FOREIGN KEY ', '(', COLUMN_NAME,')',
				' REFERENCES ', REFERENCED_TABLE_NAME, ' (', REFERENCED_COLUMN_NAME, ');'
             ) as ''
			 
	FROM information_schema.TABLE_CONSTRAINTS tc
		INNER JOIN information_schema.KEY_COLUMN_USAGE kcu
			ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
	WHERE kcu.CONSTRAINT_SCHEMA = 'Chinook'
		AND tc.TABLE_SCHEMA = 'Chinook'AND tc.CONSTRAINT_TYPE = 'FOREIGN KEY';