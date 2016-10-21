<!--
    <div class="container">
    <div class="row">
    -->

   <table class="table table-striped">
    <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>ChipID</th>
          <th>Description</th>
          <th>Update</th>
          <th></th>
        </tr>
    </thead>
    
    <tbody>
    <?php
	mysql_connect("localhost", "root", "evka3380") or die(mysql_error());
	mysql_select_db("esp") or die(mysql_error());
	mysql_query("set names 'utf8'");

	$sql = mysql_query("SELECT * FROM esp ORDER BY id DESC") or die(mysql_error());
	while ($esp = mysql_fetch_assoc($sql)) {
    if ($esp[update] == 1) {$upd = "Yes";} else {$upd = "No";}
		echo "<tr>";
		echo "<th scope='row'>$esp[id]</th><td>$esp[name]</td><td>$esp[chip_id]</td><td>$esp[description]</td><td>$upd</td><td><a href='?edit=$esp[id]' class='btn btn-info' role='button'>Edit</a>&nbsp;<a href='?upd=$esp[id]' class='btn btn-warning' role='button'>Update</a>&nbsp;<a href='?del=$esp[id]' class='btn btn-danger' role='button'>Delete</a>&nbsp;<a href='?files=$esp[id]' class='btn btn-success' role='button'>Files</a></td>";
		echo "<tr>";
	}
    ?>
    </tbody>
    </table>


<!--
</div>
</div>
-->
