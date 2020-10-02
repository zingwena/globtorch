<?php
 
//Define your Server host name here.
$HostName = "localhost";
 
//Define your MySQL Database Name here.
$DatabaseName = "id14533966_globtorchdb";
 
//Define your Database User Name here.
$HostUser = "id14533966_warren";
 
//Define your Database Password here.
$HostPass = "zingwenaW@1997"; 
 
// Creating MySQL connection.
$con = mysqli_connect($HostName,$HostUser,$HostPass,$DatabaseName);
 
// Storing the received JSON in $json.
$json = file_get_contents('php://input');
 
// Decode the received JSON and store into $obj
$obj = json_decode($json,true);
 
// Getting name from $obj.
$name = $obj['name'];
 
// Getting email from $obj.
$surname = $obj['surname'];

// Getting email from $obj.
$phone = $obj['phone'];

// Getting email from $obj.
$email = $obj['email'];
// Getting email from $obj.
$country = $obj['country'];
// Getting email from $obj.
$password = $obj['password'];
 
// Getting phone number from $obj.
$referral = $obj['referral'];
 
// Creating SQL query and insert the record into MySQL database table.
$Sql_Query = "insert into user_info (name, surname,phone, email,country,password, referral) values ('$name','$surname', '$phone','$email','$country', '$password','$referral')";
 
 
 if(mysqli_query($con,$Sql_Query)){
 
	 // On query success it will print below message.'$email'
	$MSG = 'Data Successfully Submitted.' ;
	 
	// Converting the message into JSON format.
	$json = json_encode($MSG);
	 
	// Echo the message.
	 echo $json ;
 
 }
 else{
 
	echo 'Try Again';
 
 }
 mysqli_close($con);
?>