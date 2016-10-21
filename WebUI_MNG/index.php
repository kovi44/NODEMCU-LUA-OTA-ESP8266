<?php 
    require("config.php"); 


$valid_formats = array("lua", "txt", "mono", "html", "htm");
$max_file_size = 1024*100; //100 kb
$path = "uploads/"; // Upload directory
$count = 0;
if(isset($_GET) and $_SERVER['REQUEST_METHOD'] == "GET"){

  $nodeIdDel = $_GET['del'];
  
  if (isset($_GET['del'])) {
    $sql = "DELETE FROM esp WHERE id=$nodeIdDel";
    $db->exec($sql);
  }
  $nodeIdUpd = $_GET['upd'];
  
  if (isset($_GET['upd'])) {
    $sql = "SELECT * FROM esp WHERE id=$nodeIdUpd";
    $sth = $db->prepare($sql);
    $sth->execute();
    $result = $sth->fetch(PDO::FETCH_ASSOC);

    if ($result[update] == 1) {$val = 0;} else {$val = 1;}

    $sql = "UPDATE esp SET `update`='$val' WHERE id=$nodeIdUpd";
    $db->exec($sql);
  }

}

if(isset($_POST) and $_SERVER['REQUEST_METHOD'] == "POST"){
  if (isset($_POST['fileEditor_id'])) {
      $eFile_id = $_POST['fileEditor_id'];
      $eFile_data = $_POST['fileEditor_data'];

      $sql = "SELECT * FROM data WHERE id=$eFile_id";
      $sth = $db->prepare($sql);
      $sth->execute();
      $result = $sth->fetch(PDO::FETCH_ASSOC);

      $r_folder = $result[folder];
      $r_filename = $result[filename];

      $fn = "uploads/".$r_folder."/".$r_filename;
      $file = fopen($fn, "w"); 
      $size = filesize($fn); 
      fwrite($file, $eFile_data);
      fclose($file); 

  } else {

      // Loop $_FILES to execute all files
      $chipid = $_POST['chipid'];
      $nodeDesc = $_POST['Ndesc'];
      $nodeName = $_POST['Nname'];
      $nodeEdit = $_POST['edit'];

      if (isset($_POST['esp_id'])) {
        $esp_id = $_POST['esp_id'];
        $sql = "SELECT * FROM esp WHERE id='$esp_id'";
        $sth = $db->prepare($sql);
        $sth->execute();
        $chip_id_fetch = $sth->fetch(PDO::FETCH_ASSOC);
        $chipid = $chip_id_fetch[chip_id];

        } else {

        if (isset($_POST['edit'])) {
            $sql = "UPDATE esp SET `name` = '$nodeName', `description` = '$nodeDesc', `chip_id` = '$chipid' WHERE id = $nodeEdit";
            $db->exec($sql);
        } else {
            $sql = "INSERT INTO esp (name,description,chip_id) VALUES ('$nodeName','$nodeDesc','$chipid')";
            $db->exec($sql);
        }

        $sql = "SELECT * FROM esp WHERE chip_id='$chipid'";
        $sth = $db->prepare($sql);
        $sth->execute();
        $esp_id_fetch = $sth->fetch(PDO::FETCH_ASSOC);
        $esp_id = $esp_id_fetch[id];
        }

      foreach ($_FILES['files']['name'] as $f => $name) {     
          if ($_FILES['files']['error'][$f] == 4) {
              continue; // Skip file if any error found
          }        
          if ($_FILES['files']['error'][$f] == 0) {            
              if ($_FILES['files']['size'][$f] > $max_file_size) {
                  $message[] = "$name is too large!.";
                  continue; // Skip large files
              }
          elseif( ! in_array(pathinfo($name, PATHINFO_EXTENSION), $valid_formats) ){
            $message[] = "$name is not a valid format";
            continue; // Skip invalid file formats
          }
              else{ // No error found! Move uploaded files
                  if (!file_exists($path.$chipid)) {
                    mkdir($path.$chipid, 0777, true);
                  }
                  if(move_uploaded_file($_FILES["files"]["tmp_name"][$f], $path.$chipid."/".$name)) {
                    $count++; // Number of successfully uploaded files
                  }

                  $sql = "INSERT INTO data (folder,filename,esp_id) VALUES ('$chipid','$name','$esp_id')";
                  $db->exec($sql);
              }
          }
      }
  }
}
?>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../favicon.ico">
    <title>ESP Management tool </title>
    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="css/jumbotron.css" rel="stylesheet">
    <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
    <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
    <script src="js/ie-emulation-modes-warning.js"></script>
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>

    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="index.php">ESP Management tool</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
            <form id="form" role="form" class="navbar-form navbar-right">
            <div class="form-group"> 
            
            

           </div>
           </form>
        </div><!--/.navbar-collapse -->
      </div>
    </nav>

    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div class="jumbotron">
      <div class="container">
	<p>IoT Management platform based on esp8266 chipset and nodemcu firmware using lua interpreter.</p>            
      </div>
    </div>
    
            
    <div class="container">
    <h4>List of managed ESPs <a href='?newnode=1' class='btn btn-danger pull-right' role='button'>Add new Node</a></h4><hr>
<?php include("esp_list.php") ?>
    </div>

    <div class="container">
      <?php
        if (isset($_GET[files])) {

          $fileId = $_GET[files];

          if (isset($_GET[boot])) {
                  $file_id = $_GET[boot];

                  $sql = "SELECT * FROM data WHERE esp_id=$fileId";
                  $files = $db->query($sql);
                  foreach ($files as $value) {
                      if ($file_id == $value[id]) {
                          $sql = "UPDATE data SET `boot`=1 WHERE id=$value[id]";
                          $db->exec($sql);
                      } else {
                          $sql = "UPDATE data SET `boot`=0 WHERE id=$value[id]";
                          $db->exec($sql);
                      }
                  }
          }

          if (isset($_GET[delfile])) {
                  $file_del = $_GET[delfile];
                  
                  $sql = "DELETE FROM data WHERE id=$file_del";
                  $db->exec($sql);
          }
              echo "<br/><br/><h4>List of files to be downloaded by esp ";
              echo "<form id='form' role='form'  action='' method='POST' class='navbar-form navbar-right' enctype='multipart/form-data'>
                      
                        <div class='input-group'>
                            <span class='input-group-btn'>
                                <span class='btn btn-primary btn-file'>
                                Browse&hellip; 
                                <input id='file' type='file' name='files[]' multiple/>
                                </span>
                            </span>
                            <input type='text' class='form-control' readonly>
                        </div>
                      
                      <div class='form-group'> 
                      <input type='hidden' value=$fileId name='esp_id' />
                      <button type='submit' class='btn btn-success'>Upload</button>
                     </div>
                     
                    </form>";

              echo "</h4><hr>";
             echo "<table class='table table-striped'>
              <thead>
                  <tr>
                    <th>File ID</th>
                    <th>Filename</th>
                    <th>Folder</th>
                    <th>Boot flag</th>
                    <th></th>
                  </tr>
              </thead>
              <tbody>
              ";
                
                $sql = "SELECT * FROM data WHERE esp_id='$fileId'";
                $files = $db->query($sql);
                //$file = $files->fetch(PDO::FETCH_ASSOC);
                
                foreach ($files as $value) {

                    echo "<tr>";
                    echo "<th scope='row'>$value[id]</th><td>$value[filename]</td><td>$value[folder]</td><td>$value[boot]</td><td><a href='?files=$value[esp_id]&delfile=$value[id]' class='btn-sm btn-danger' role='button'>Delete</a>&nbsp;<a href='?files=$value[esp_id]&boot=$value[id]' class='btn-sm btn-success' role='button'>Boot Flag</a>&nbsp;<a href='?editor=$value[id]' class='btn-sm btn-primary' role='button'>Edit</a></td>";
                    echo "<tr>";
                  }
            echo "  </tbody>
              </table>";
        }
      ?>
    </div>
    

<?php
    if (isset($_GET[newnode]) || isset($_GET[edit]) ) {

      if (isset($_GET[edit])) {

        $nodeIdUpd = $_GET['edit'];
  
        $sql = "SELECT * FROM esp WHERE id=$nodeIdUpd";
        $sth = $db->prepare($sql);
        $sth->execute();
        $result = $sth->fetch(PDO::FETCH_ASSOC);

        $r_name = $result[name];
        $r_desc = $result[description];
        $r_chipid = $result[chip_id];
      }



  echo " <div class='container'>
  <br /> <br />
    <form class='form-horizontal' action='?' method='POST' enctype='multipart/form-data'>
    <h4>Add new Node 
    <button id='submit' name='submit' class='btn btn-danger pull-right'>Submit</button></h4><hr>

        
           

            <!-- Text input-->
            <div class='form-group'>
              <label class='col-md-4 control-label' for='Node name'>Node name</label>  
              <div class='col-md-4'>
              <input id='Nname' name='Nname' type='text' placeholder='Enter a node name' class='form-control input-md' value='$r_name'>
                
              </div>
            </div>

            <!-- Textarea -->
            <div class='form-group'>
              <label class='col-md-4 control-label' for='description'>Node description</label>
              <div class='col-md-4'>                     
                <textarea class='form-control' id='Ndesc' name='Ndesc' placeholder='Enter a description'>$r_desc</textarea>
              </div>
            </div>

            <!-- Text input-->
            <div class='form-group'>
              <label class='col-md-4 control-label' for='chipid'>ChipID</label>  
              <div class='col-md-4'>
              <input id='chipid' name='chipid' type='text' placeholder='Place the ChipID of the esp node' class='form-control input-md' value='$r_chipid'>
                
              </div>
            </div>

            <!-- File Button --> 
            <div class='form-group'>
              <label class='col-md-4 control-label' for='file'>Script file</label>
              <div class='col-md-4'>
                
                <label class='btn-sm btn-primary'>
                Browse… <input id='file' style='display: none;' type='file' class='input-file' name='files[]'' multiple/>
                </label>
              </div>
            </div>";

            if (isset($_GET[edit])) { echo "<input type='hidden' value=$nodeIdUpd name='edit' />";}
            echo "

        </form>
</div>";
}
?>

<?php
    if (isset($_GET[editor])) {

        $fileId = $_GET['editor'];
  
        $sql = "SELECT * FROM data WHERE id=$fileId";
        $sth = $db->prepare($sql);
        $sth->execute();
        $result = $sth->fetch(PDO::FETCH_ASSOC);

        $r_folder = $result[folder];
        $r_filename = $result[filename];
        $r_espid = $result[esp_id];

        $fn = "uploads/".$r_folder."/".$r_filename;
        $file = fopen($fn, "a+"); 
        $size = filesize($fn); 
        $text = fread($file, $size); 
        fclose($file); 


  echo " <div class='container'>
  <br /> <br />
    <form class='form-horizontal' action='?files=$r_espid' method='POST' enctype='multipart/form-data'>
    <h4>Online file editor - $r_filename
    <button id='submit' name='submit' class='btn btn-danger pull-right'>Modify</button></h4><hr>

            <!-- Textarea -->
            <div class='form-group'>
              <div class='col-md-12'>                     
                <textarea class='form-control' id='fileEditor' name='fileEditor_data' style='min-width: 100%' rows='10'>$text</textarea>
              </div>
            </div>";

            echo "<input type='hidden' value=$fileId name='fileEditor_id' />";
            echo "

        </form>
</div>";
}
?>

      <footer>
      </footer>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/ie10-viewport-bug-workaround.js"></script>
  </body>
</html>



