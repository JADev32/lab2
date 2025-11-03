<?php
return new PDO(
    "mysql:host=mysql-service-ec2.ecs-internal;dbname=app_db", 
    "root", 
    "password", 
    [PDO::ATTR_PERSISTENT => true]
);