<?php

return new Service\TweetsService(
    require __DIR__ . "/../config/db-connection.php"
);