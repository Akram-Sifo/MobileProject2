<?php
header("Access-Control-Allow-Origin: *"); // Allows all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allowed HTTP methods
header("Access-Control-Allow-Headers: Content-Type, Authorization"); // Allowed headers
?>
<?php
$host ='fdb1029.awardspace.net';
$user ='4568851_sifo';
$password ='12345678az';
$dbname = '4568851_sifo';
// Create a connection
$con = new mysqli($host, $user, $password, $dbname);

$sql = "SELECT id, name, description, credits FROM subjects";
$result = mysqli_query($con, $sql);

$subjects = array();
while ($row = mysqli_fetch_assoc($result)) {
    $subjects[] = $row;
}

echo json_encode($subjects);
?>