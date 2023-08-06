class_name Collision extends Node


#collider: The colliding object.
#collider_id: The colliding object's ID.
#normal: The object's surface normal at the intersection point, or Vector2(0, 0) if the ray starts inside the shape and PhysicsRayQueryParameters2D.hit_from_inside is true.
#position: The intersection point.
#rid: The intersecting object's RID.
#shape: The shape index of the colliding shape.
#If the ray did not intersect anything, then an empty dictionary is returned instead.
static func ray(from:Vector2, to:Vector2, world:World2D):
	var space = world.direct_space_state;
	var query = PhysicsRayQueryParameters2D.create(from, to)
	return space.intersect_ray(query);


#collider: The colliding object.
#collider_id: The colliding object's ID.
#rid: The intersecting object's RID.
#shape: The shape index of the colliding shape.
static func point(point:Vector2, world:World2D):
	var space = world.direct_space_state;
	var query = PhysicsPointQueryParameters2D.new()
	query.position = point;
	return space.intersect_point(query);
