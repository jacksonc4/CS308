<?php 
	// Proof of concept insert to database
	// After tinkering with this for a while we decided to not use PHP
	// for the server side of the front end
	$x = 0;
?>


<html>
	<head>

		<title> Response Page </title>
	</head>

	<p> Inserted... <br>
		<b>UserID:</b> 		<?php echo $_POST["userID"] ?>  	<br>
		<b>First Name:</b> 	<?php echo $_POST["first_name"] ?> 	<br>
		<b>Last Name:</b> 	<?php echo $_POST["last_name"] ?> 	<br>
		<b>Class:</b> 		<?php echo $_POST["class"] ?> 		<br>
	</p>


</html>

<?php

// We are using the connection code provided by 
// https://github.com/duoshuo/php-cassandra
include '/php-cassandra.php';
// Multiple cassandra nodes can be connected to
$nodes = [
	// Displays various ways to connect
    '127.0.0.1',        
    '192.168.0.2:9042', 
    [               
        'host'      => '10.205.48.70',
        'port'      => 9042, //default 9042
        'username'  => 'admin',
        'password'  => 'pass',
        'socket'    => [SO_RCVTIMEO => ["sec" => 10, "usec" => 0]]
    ]
];

//Connects to specificed noes at keyspace demo
$connection = new Cassandra\Connection($nodes, 'demo');

//Prepares the string of columns
$columnString = '(userID,first_name,last_name,class)';

//Prepares the string of values
$valueString = '('.
	new Cassandra\Type\Varchar($_POST["userID"]).','.
	new Cassandra\Type\Varchar($_POST["first_name"]).','.
	new Cassandra\Type\Varchar($_POST["last_name"]).','.
	new Cassandra\Type\Varchar($_POST["class"]).');';	



$x = 1;
try {
	//Attempts insert
    $response = $connection->querySync('INSERT INTO "USERS" '.$columnString.' VALUES '.$valueString);
}
catch (Cassandra\Exception $e){$x=0;}

//Informs user of failed insert
if($x == 0) {
	echo "Insert Failed";
}