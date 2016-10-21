<?php
// Connects to your Database.
mysql_connect("localhost", "root", "evka3380") or die(mysql_error());
mysql_select_db("stb") or die(mysql_error());
mysql_query("set names 'utf8'");

$comment = $_POST["comment"];
$file = $_FILES["file"]["name"];

  if ($_FILES["file"]["error"] > 0)
    {
    echo "Return Code: " . $_FILES["file"]["error"] . "<br />";
    }
  else
    {   
    if (file_exists("upload/" . $_FILES["file"]["name"]))
      {
      echo $_FILES["file"]["name"] . " already exists. ";
      }
    else
      {
      move_uploaded_file($_FILES["file"]["tmp_name"],
      "upload/" . $_FILES["file"]["name"]);
      echo "Stored in: " . "upload/" . $_FILES["file"]["name"];
	mysql_query("INSERT INTO files (filename,comment) VALUES ('$file','$comment')") or die(mysql_error());
      }
    }
?>
