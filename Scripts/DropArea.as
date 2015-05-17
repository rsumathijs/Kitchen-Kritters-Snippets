package 
{
	import flash.display.MovieClip;

	//class representing the plate where the players drop off their ingredients
	public class DropArea extends MovieClip
	{
		private var holdingItem:Boolean; //indicates if there is an item on the cutting board
		private var itemsList:Array;

		//constructor to initialise
		public function DropArea()
		{
			holdingItem = false;
			itemsList = new Array();
		}

		public function setHolding(holding:Boolean)
		{
			this.holdingItem = holding;
		}

		public function isHolding():Boolean
		{
			return holdingItem;
		}

		public function addtoBoard(ingredient:Ingredient)
		{
			itemsList.push(ingredient);
		}

		//take out the first item from the array and return it
		public function removeFromBoard():Ingredient
		{
			//remove only if there is no item on the cutting board
			if (holdingItem == false)
			{
				var ingredient:Ingredient = itemsList.shift();
				addChildAt(ingredient, 1);
				holdingItem = true;
				return ingredient;
			}

			return null;
		}

		public function getSize():uint
		{
			return itemsList.length;
		}
		
		public function clearCuttingBoard()
		{
			itemsList.splice(0); //clear out the array

			//if there is an item on the board at the time of the function call, remove that
			if (holdingItem)
			{
				this.removeChildAt(1);
				holdingItem = false;
			}
		}
	}
}