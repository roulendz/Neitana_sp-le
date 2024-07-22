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

	# Store spawned positions to avoid overlaps
	var spawned_coords = []

	for cluster_data in cluster_list:
		var cluster_size = cluster_data["cluster_size"]
		var cluster_coord = cluster_data["cluster_coord"]

		if cluster_size >= min_cluster_size and random.randf() < spawn_chance:
			var max_enemies = 1 if cluster_size > 10 else 1
			var min_enemies = 1 if max_enemies > 0 else 0
			var num_enemies = random.randi_range(min_enemies, max_enemies)
			var enemy_scene = load("res://scenes/Enemy.tscn")

			for _i in range(num_enemies):
				var spawn_coord = null
				var attempts = 0
				var max_attempts = 10  # Maximum attempts to find a valid spot

				while spawn_coord == null and attempts < max_attempts:
					var random_coord_index = random.randi_range(0, cluster_coord.size() - 1)
					var potential_coord = cluster_coord[random_coord_index]
					var _potential_position = tilemap.map_to_local(potential_coord)

					# Check for overlap
					var overlap = false
					for coord in spawned_coords:
						if Vector2(potential_coord).distance_to(Vector2(coord)) < 2:
							overlap = true
							break

					
					if not overlap:
						spawn_coord = potential_coord
					attempts += 1

				# If we couldn't find a valid spawn coord, skip this enemy
				if spawn_coord == null:
					continue

				# Valid spawn position found
				spawned_coords.append(spawn_coord)
				var spawn_position = tilemap.map_to_local(spawn_coord)

				var new_enemy = enemy_scene.instantiate()
				add_child(new_enemy)
				new_enemy.global_position = spawn_position

			var cluster_key = str(cluster_coord[0])
			enemy_placement[cluster_key] = num_enemies

	return enemy_placement










	
	

func _ready():
	
	# Assuming your TileMap node is named "TileMap" and under a node named "GameLevel2" in the scene tree.
	var tilemap = get_parent()

	# Error checking
	if tilemap is TileMap:
		#print(tilemap.get_cell_tile_data(0,Vector2i(0,0)))
		var possible_coords_for_enemies = get_possible_cell_coords_for_enemie_placement(tilemap)

		var min_cluster_size = 8
		var spawn_chance = 1

		var ar_clusters = analyze_tile_clusters(possible_coords_for_enemies)
		var _enemy_placement = determine_enemy_placement(ar_clusters, min_cluster_size, spawn_chance, tilemap)  # Pass the tilemap
