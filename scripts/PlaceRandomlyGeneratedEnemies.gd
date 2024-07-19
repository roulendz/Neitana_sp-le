extends Node2D 

func get_possible_cell_coords_for_enemie_placement(tilemap: TileMap) -> Array:
	var used_cells = tilemap.get_used_cells(0)
	var  possible_coords_for_enemies := []
	var desired_atlas_coords = PackedVector2Array([Vector2(0,0), Vector2(2,0), Vector2(4,0), Vector2(6,0), Vector2(7,0), Vector2(7,1)])

	for used_cell in used_cells:
		var atlas_coord = tilemap.get_cell_atlas_coords(0, used_cell)
		var atlas_coord_vector2 = Vector2(atlas_coord) # Convert to Vector2

		# Check if atlas_coord is in the desired list
		if atlas_coord_vector2 in desired_atlas_coords:
			var tilemap_coord = used_cell 
			var tile_data = {
				"coord": tilemap_coord,
				#"atlas_coord": atlas_coord
			}
			possible_coords_for_enemies.append(tile_data)

	#print(possible_coords_for_enemies)
	return possible_coords_for_enemies

func analyze_tile_clusters(possible_coords_for_enemies: Array) -> Array:
	var clusters = []  
	var visited = []  

	for tile_data in possible_coords_for_enemies:
		var coord = tile_data["coord"]  # coord is now Vector2i

		if coord in visited:  # Directly check if Vector2i is in the visited array
			continue  

		var cluster = [coord]  
		var queue = [coord]  

		while queue.size() > 0:  
			var current = queue.pop_front()
			visited.append(current)  # Add Vector2i to the visited array

			for offset in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:  # Use Vector2i offsets
				var neighbor = current + offset  # Now both are Vector2i
				var neighbor_data = {"coord": neighbor}

				if neighbor_data in possible_coords_for_enemies and neighbor not in visited:
					cluster.append(neighbor)
					queue.append(neighbor) 

		clusters.append(cluster)  

	clusters = clusters.filter(func(cluster): return cluster.size() > 1)
	var  cluster_list := []
	for cluster in clusters:
		var cluster_data = {
			"cluster_size": cluster.size(),
			"cluster_coord": cluster
		}
		cluster_list.append(cluster_data)
	
	#print(cluster_list)
	return cluster_list

func determine_enemy_placement(cluster_list: Array, min_cluster_size: int, spawn_chance: float, tilemap: TileMap) -> Dictionary:
	var enemy_placement = {}
	var random = RandomNumberGenerator.new()

	for cluster_data in cluster_list:
		var cluster_size = cluster_data["cluster_size"]
		var cluster_coord = cluster_data["cluster_coord"]  # Array of Vector2i coordinates in the cluster

		if cluster_size >= min_cluster_size and random.randf() < spawn_chance:
			var max_enemies = 10 if cluster_size > 6 else 1
			var min_enemies = 1 if max_enemies > 0 else 0
			var num_enemies = random.randi_range(min_enemies, max_enemies)
			#print("min:" + str(min_enemies) + " | max:" + str(max_enemies) + " | enem:" + str(num_enemies))
			var enemy_scene = load("res://scenes/Enemy.tscn")  # Load your enemy scene

			for _i in range(num_enemies):
				var random_coord_index = random.randi_range(0, cluster_coord.size() - 1)
				var spawn_coord = cluster_coord[random_coord_index]

				# Get the world position from the tilemap coordinates
				var spawn_position = tilemap.map_to_local(spawn_coord) 

				# Instantiate and place the enemy
				var new_enemy = enemy_scene.instantiate()
				add_child(new_enemy)  # Add to the scene tree (replace with your parent node if needed)
				new_enemy.global_position = spawn_position

			var cluster_key = str(cluster_coord[0])  # Still use the first coord for the key
			enemy_placement[cluster_key] = num_enemies  # Store for reference (optional)

	return enemy_placement

	
	

func _ready():
	# Assuming your TileMap node is named "TileMap" and under a node named "GameLevel2" in the scene tree.
	var tilemap = get_parent()

	# Error checking
	if tilemap is TileMap:
		#print(tilemap.get_cell_tile_data(0,Vector2i(0,0)))
		var possible_coords_for_enemies = get_possible_cell_coords_for_enemie_placement(tilemap)

		var min_cluster_size = 5
		var spawn_chance = 1

		var ar_clusters = analyze_tile_clusters(possible_coords_for_enemies)
		var enemy_placement = determine_enemy_placement(ar_clusters, min_cluster_size, spawn_chance, tilemap)  # Pass the tilemap
