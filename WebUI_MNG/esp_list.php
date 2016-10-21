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
          <th>Last heartbeat</th>
          <th></th>
        </tr>
    </thead>
    
    <tbody>
    <?php

  $sql = "SELECT * FROM esp ORDER BY id DESC";
  $data = $db->query($sql);
  foreach ($data as $esp) {

    if ($esp[update] == 1) {$upd = "Yes";} else {$upd = "No";}
		echo "<tr>";
		echo "<th scope='row'>$esp[id]</th><td>$esp[name]</td><td>$esp[chip_id]</td><td>$esp[description]</td><td>$upd</td><td>$esp[heartbeat]</td><td><a href='?edit=$esp[id]' class='btn-sm btn-info' role='button'>Edit</a>&nbsp;<a href='?upd=$esp[id]' class='btn-sm btn-warning' role='button'>Update</a>&nbsp;<a href='?del=$esp[id]' class='btn-sm btn-danger' role='button'>Delete</a>&nbsp;<a href='?files=$esp[id]' class='btn-sm btn-success' role='button'>Files</a></td>";
		echo "<tr>";

	}
    ?>
    </tbody>
    </table>


<!--
</div>
</div>
-->
