<?php
require __DIR__ . "/../config/db-connection.php";

return new Service\UsersService(
    require __DIR__ . "/../config/db-connection.php"
);