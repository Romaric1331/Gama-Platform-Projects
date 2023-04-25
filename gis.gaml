/**
* Name: GISdata
* Based on the internal skeleton template. 
* Author: Romaric Sallustre
* Tags: 
*/

model Road_traffic_model

global {
	// drag and drop the file from include (loading files)
	shape_file bounds0_shape_file <- shape_file("../includes/bounds.shp");

	shape_file building0_shape_file <- shape_file("../includes/building.shp");

	shape_file road0_shape_file <- shape_file("../includes/road.shp");
	
	float step<- 10#mn; // assigning a timestep of 10 minute intervals
						//  1 step by an agent= 10 minutes
						
	geometry shape <- envelope(building0_shape_file); // geometry w.r.to bounds
	
	int nb_people<- 100;
	
	init{
		// create building from shape file with type as residential initially and if case for industrial
		create building from: building0_shape_file with:[type:read("NATURE")]{
			if type="Industrial"{
				color<-#yellow;
			}
		}
		
		create road from:road0_shape_file;
		// create buildings which are residential
		list<building> residential_building<-building where (each.type="Residential");
		
		// create people agents in the resi. buildings
		create people number:nb_people{
			location<-any_location_in(one_of(residential_building));
		}
		
		
	}

	
}

species building{
	string type; // type of the building (residential, industrial)
	rgb color<-#gray; // building color

	aspect base{ // display settings of the simulation (default is an initial typ)e
		draw shape color:color depth:rnd(100); // draw the shape with the color attri
	}
}

species road{
	rgb color<-#black; 
	
	aspect base{
		draw shape color:color;
	}
	
}

species people skills:[moving]{
	rgb color <- #red; 
	// adding attributes
	building living_place<- nil; //currently these are nil 
	building working_place<- nil;
	int start_work;
	int end_work;
	string objective;
	point the_target<- nil; 
	
	// addede reflexes time to work, and time to go home
	
	reflex time_to_work when: current_date.hour = start_work and objective = "resting"{
			objective <- "working";
			the_target <- any_location_in (working_place);
	}
	reflex time_to_go_home when: current_date.hour = end_work and objective = "working"{
		objective <- "resting";
		the_target <- any_location_in (living_place);
	}
	aspect base{
		draw circle(10) color:color border:#black;
	}
	
}

experiment Road_traffic_model type: gui {
	parameter "Shapefile for buildings:" var: building0_shape_file category:"GIS";
	parameter "Shapefile for bounds:" var: bounds0_shape_file category:"GIS";
	parameter "Shapefile for roads:" var: road0_shape_file category:"GIS";
	
	parameter "Number of people agents" var: nb_people category:"People"; // adding for people
	
	
	output {
		display city_display type:3d{  // creation of 3D display
			species building aspect:base; // adding building species to the sim
			species road aspect: base; // adding rad species to the sime
			species people aspect: base;
		}
	}
}
