<?php
return new PDO(
    "mysql:host=10.0.10.249;dbname=app_db", 
    "root", 
    "password", 
    [PDO::ATTR_PERSISTENT => true]
);