/**
* Name: CHl
* Based on the internal skeleton template. 
* Author: romar
* Tags: 
*/

model CHl

global {
	int nba <-1000 parameter:true min: 100 max:1000;
	float pch <-0.5  parameter: true min:0.0 max:1.0; // flip
	
	init{
		create people number:nba{ // choosing one of 100
				//write sample(self);
				//status <- flip (pch) ? "coward" : "hero";
				//write status;
				friend <- any(people - self); // choosing any people except you
				//write sample(friend);
				enemy <- any(people - self - friend); // choosing an enemy who is not a friend or yourself
				//write sample(enemy);
			}
			int num_of_cowards <- int(length(people)*pch);
			list cowards <- int(length(people) * pch)among people;
			//list cowards <- among(int(length(people) * pch),people);
			ask cowards { status <-"coward";}
			list heroes <- people - cowards;
			ask heroes { status <-"hero";}
			}
}
species people skills:[moving]{
	string status;
	
	people friend;
	people enemy;
	
	reflex gotdestination {
	//	location <- destination(status);
	do goto target:destination(status);
	}
	point destination(string s) {// point is replace with 'def'
		if s='coward'{
			//point f <- friend.location;
			//point e <- enemy.location;
			return friend.location - enemy.location + friend.location;
		}
		else{
			return (friend.location - enemy.location)/ 2;
		}
	}
	
	
	//geometry shape <- flip(0.7) ? triangle(1#m) : circle(0.5#m);
	
	aspect default {
		draw triangle(4#m) color:status ='coward'? #steelblue : #red rotate: heading + 90.0;
	}
}
experiment CHl type: gui {
	
	float minimum_cycle_duration <-0.1;
	
	user_command Relocate {ask people {location <- any_location_in(world.shape);}}
	init{
		create simulation with: [pch:0.25];
		create simulation with: [pch:0.35];
		create simulation with: [pch:0.45];
	}
	output {
		display main type:3d {
			species people trace:true fading:true;
		}
	}
}
