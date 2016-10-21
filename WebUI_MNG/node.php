<?php
require("config.php"); 
$chipid = $_GET['id'];

if (isset($_GET['list'])) {
	$sql = "SELECT * FROM esp WHERE chip_id='$chipid'";
    $sth = $db->prepare($sql);
    $sth->execute();
    $esp_id_fetch = $sth->fetch(PDO::FETCH_ASSOC);
    $esp_id = $esp_id_fetch[id];

	$sql = "SELECT * FROM data WHERE esp_id='$esp_id' ORDER BY `boot` DESC";
    $files = $db->query($sql);

    foreach ($files as $value) {
    	echo $value[filename]."\n";
    }

}

if (isset($_GET['update'])) {
	$sql = "SELECT * FROM esp WHERE chip_id='$chipid'";
    $sth = $db->prepare($sql);
    $sth->execute();
    $fetch = $sth->fetch(PDO::FETCH_ASSOC);
    $result = $fetch[update];

    if ($result == 1) {
        echo "UPDATE";
        $sql = "UPDATE `esp` SET `update`=0 WHERE chip_id=$chipid";
        $db->exec($sql);
    } else {echo "";} 

    $sql = "UPDATE `esp` SET heartbeat=now() WHERE chip_id=$chipid";
    $db->exec($sql);


}

?>