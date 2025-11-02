<?php
return new PDO(
    "mysql:host=mysql-service-ec2;dbname=app_db", 
    "root", 
    "password", 
    [PDO::ATTR_PERSISTENT => true]
);