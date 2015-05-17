package 
{
	import flash.display.MovieClip;

	//class to represent the thought bubbles of the two chefs
	public class ThoughtBubble extends MovieClip
	{
		private var ingred1:Ingredient;
		private var ingred2:Ingredient;
		private var ingred3:Ingredient;

		//draw the first three ingredients with the required scale and alpha
		public function ThoughtBubble(ingredPos:Array, scales:Array)
		{
			ingred1 = new Ingredient(0, "fish", 0);
			ingred1.x = ingredPos[0].x;
			ingred1.y = ingredPos[0].y;
			ingred1.scaleX = ingred1.scaleY = scales[0];
			ingred1.alpha = 1;
			this.addChildAt(ingred1, 1);

			ingred2 = new Ingredient(0, "fish", 0);
			ingred2.x = ingredPos[1].x;
			ingred2.y = ingredPos[1].y;
			ingred2.scaleX = ingred2.scaleY = scales[1];
			ingred2.alpha = 0.4;
			this.addChildAt(ingred2, 2);

			ingred3 = new Ingredient(0, "fish", 0);
			ingred3.x = ingredPos[2].x;
			ingred3.y = ingredPos[2].y;
			ingred3.scaleX = ingred3.scaleY = scales[2];
			ingred3.alpha = 0.4;
			this.addChildAt(ingred3, 3);
		}

		public function setSequence(ingreds:Array)
		{
			ingred1.setName(ingreds[0]);
			ingred2.setName(ingreds[1]);
			ingred3.setName(ingreds[2]);
		}
	}
}