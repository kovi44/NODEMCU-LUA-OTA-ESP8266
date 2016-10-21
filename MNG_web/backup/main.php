<?php 
    require("config.php"); 
    $submitted_username = ''; 
    if(!empty($_POST)){ 
        $query = " 
            SELECT 
                id, 
                username, 
                password,
                salt, 
                email 
            FROM users 
            WHERE 
                username = :username 
        "; 
        $query_params = array( 
            ':username' => $_POST['username'] 
        ); 
         
        try{ 
            $stmt = $db->prepare($query); 
            $result = $stmt->execute($query_params); 
        } 
        catch(PDOException $ex){ die("Failed to run query: " . $ex->getMessage()); } 
        $login_ok = false; 
        $row = $stmt->fetch(); 
        if($row){ 
            $check_password = hash('sha256', $_POST['password'] . $row['salt']); 
            for($round = 0; $round < 65536; $round++){
                $check_password = hash('sha256', $check_password . $row['salt']);
            } 
            if($check_password === $row['password']){
                $login_ok = true;
            } 
        } 

        if($login_ok){ 
            unset($row['salt']); 
            unset($row['password']); 
            $_SESSION['user'] = $row;  
            header("Location: main.php"); 
            die("Redirecting to: main.php"); 
        } 
        else{ 
            print("Login Failed."); 
            $submitted_username = htmlentities($_POST['username'], ENT_QUOTES, 'UTF-8'); 
        } 
    } 
?>

<?php
    require("config.php");
    if(empty($_SESSION['user']))
        {
        header("Location: index.php");
        die("Redirecting to index.php");
        }
?> 


<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../favicon.ico">

    <title>Firmware development | File sharing | Project DIGI SK & CZ</title>

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
          <a class="navbar-brand" href="#">STB Firmware development</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <form id="form" role="form" class="navbar-form navbar-right" enctype="multipart/form-data">
            <div class="form-group">
        	    <div class="input-group">
        	        <span class="input-group-btn">
        	            <span class="btn btn-primary btn-file">
        	            Browse&hellip; <input type="file" name="file" id="file" >
        	            </span>
        	        </span>
        		
        		<input type="text" class="form-control" readonly>
        	    </div>
            </div>
            <div class="form-group input-mysize">
              <input type="text" name="comment" id="comment" class="form-control" style="width:520px" placeholder="Comment place here">
            </div>
            <div class="form-group"> 
            <button type="submit" class="btn btn-success">Upload</button>
           </div>
           
          </form>
        </div><!--/.navbar-collapse -->
      </div>
    </nav>
    
    
	<div class="modal fade" id="myModal">
                <div class="modal-dialog">
                    <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                <h4 class="modal-title">Upload status</h4>
                            </div>
                            <div class="modal-body">
                                <div id="messages">
                                  <div class="progress">
                                      <div id="pbar" class="progress-bar" role="progressbar"  aria-valuemin="0" aria-valuemax="100" style="width:0%">
                                    </div>
                                  </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            </div>
                    </div>
                </div>
            </div>
            
    <div class="container">
      <!-- Example row of columns -->
      <div class="row">
      <table class="table">
      <thead>
        <tr>
          <th>#</th>
          <th>Filename</th>
          <th>Comment</th>
          <th>Upload date</th>
          <th>Download link</th>
        </tr>
      </thead>
      <tbody>
      
      <?php
      mysql_connect("localhost", "root", "evka3380") or die(mysql_error());
      mysql_select_db("esp") or die(mysql_error());
      mysql_query("set names 'utf8'");
      
          
          $sql = mysql_query("SELECT * FROM files ORDER BY id DESC") or die(mysql_error());
          while ($files = mysql_fetch_assoc($sql)) {
             echo "<tr>";
             echo "<th scope='row'>$files[id]</th><td>$files[filename]</td><td>$files[comment]</td><td>$files[timestamp]</td><td><a href='upload/$files[filename]'>Download</a></td>";
             echo "<tr>";
              }
	?>
        
      </tbody>
    </table>
	</div>

      <hr>

      <footer>
        <p>&copy; <a href="mailto:lukas@k0val.sk"> lukas@k0val.sk</a> 2015</p>
      </footer>
    </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script>
          $(document).on('change', '.btn-file :file', function () {
              var input = $(this), numFiles = input.get(0).files ? input.get(0).files.length : 1, label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
                  input.trigger('fileselect', [
                          numFiles,
                          label
                          ]);
           });
          $(document).ready(function () {
              $('.btn-file :file').on('fileselect', function (event, numFiles, label) {
              var input = $(this).parents('.input-group').find(':text'), log = numFiles > 1 ? numFiles + ' files selected' : label;
              if (input.length) {
                     input.val(log);
              } else {
                 if (log)
                 alert(log);
                 }
              });
              });
    </script>
    <script>
            $('#form').submit(function(e) {
            

                var form = $(this);
                var formdata = false;
                if(window.FormData){
                    formdata = new FormData(form[0]);
                }

                var formAction = form.attr('action');

                $.ajax({
            	      xhr: function() {
            	    	    $('#myModal').modal('show');
            	    	    
            	          var xhr = new window.XMLHttpRequest();
            	              xhr.upload.addEventListener("progress", function(evt) {
            	                    if (evt.lengthComputable) {
            	                            var percentComplete = evt.loaded / evt.total;
            	                            percentComplete = parseInt(percentComplete * 100);
            	                            //$('#messages').addClass('alert alert-danger').text(percentComplete);
            	                            //$('#messages').html(percentComplete+'%');
            	                            //$('#pbar').css("width", "percentComplete+'%'");
            	                            document.getElementById('pbar').style.width = percentComplete+'%';
            	                            //console.log(percentComplete);
            	                            if (percentComplete === 100) {
            	                    	    }
            	                    }
            	             }, false);
            	                                                                      
            	    return xhr;
            	    },
                    type        : 'POST',
                    url         : 'upload_file.php',
                    cache       : false,
                    data        : formdata ? formdata : form.serialize(),
                    contentType : false,
                    processData : false,

                    success: function(response) {
                        if(response != 'error') {
                            //$('#messages').addClass('alert alert-success').text(response);
                            // OP requested to close the modal
                            //$('#myModal').modal('show');
                            $('#messages').addClass('alert alert-success').text(response);
                        } else {
                    	     //$('#myModal').modal('show');
                            $('#messages').addClass('alert alert-danger').text(response);
                        }
                    }
                });
                e.preventDefault();
            });
            
            $('#myModal').on('hidden.bs.modal', function () {
                window.location.reload();
                })
        </script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="js/ie10-viewport-bug-workaround.js"></script>
  </body>
</html>



