package 
{
	import flash.geom.Rectangle;
	import flash.display.Sprite;

	//class to check collisions between two objects
	public class CollisionManager
	{
		//Prevents an object from moving outside the game screen area, 
		//gameArea : the rectangle representing the play area
		//target : the object to keep in the play area
		//used for around counters
		public function keepInsideGameArea(gameArea:Object, target:Player)
		{
			var halfWidth = target.width / 2;
			var halfHeight = target.height / 2;
			var leftX = target.x - halfWidth;
			var topY = target.y - halfHeight;

			//check if the object is beyond bounds and adjust the position of the target accordingly
			if (leftX < gameArea.x)
			{
				target.x = gameArea.x + halfWidth;
			}
			if (topY < gameArea.y)
			{
				target.y = gameArea.y + halfHeight;
			}
			if (leftX > gameArea.width)
			{
				target.x = gameArea.width + halfWidth;
			}
			if (topY > gameArea.height)
			{
				target.y = gameArea.height + halfHeight;
			}
		}

		//Prevents an object from going inside the specified screen area, 
		//gameArea : the rectangle representing the impassable area
		//target : the object to keep in the play area
		//used for around the cooking table
		public function keepOutsideGameArea(gameArea:Sprite, target:Player)
		{
			var targetHalfWidth = target.width / 2;
			var targetHalfHeight = target.height / 2;

			var targetLeftX = target.x - targetHalfWidth;
			var targetTopY = target.y - targetHalfHeight;

			var targetRightX = target.x + targetHalfWidth;
			var targetBottomY = target.y + targetHalfHeight;

			var gameAreaHalfWidth = gameArea.width / 2;
			var gameAreaHalfHeight = gameArea.height / 2;

			var gameAreaLeftX = gameArea.x - gameAreaHalfWidth;
			var gameAreaTopY = gameArea.y - gameAreaHalfHeight;

			var gameAreaRightX = gameArea.x + gameAreaHalfWidth;
			var gameAreaBottomY = gameArea.y + gameAreaHalfHeight;

			//check collision
			//if so, adjust the target's position
			if (gameArea.hitTestPoint(target.x, target.y))
			{
				if (targetLeftX < gameAreaLeftX)
				{
					target.x -= Constants.STEP_LENGTH;
				}
				else if (targetRightX > gameAreaRightX)
				{
					target.x += Constants.STEP_LENGTH;
				}

				if (targetTopY < gameAreaTopY)
				{
					target.y -= Constants.STEP_LENGTH;
				}
				else if (targetBottomY > gameAreaBottomY)
				{
					target.y += Constants.STEP_LENGTH;
				}
			}
		}
	}
}