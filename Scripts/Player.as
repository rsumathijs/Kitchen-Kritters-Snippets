package 
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;

	//class representing the player
	public class Player extends MovieClip
	{
		private var currentDirection:String; //current movement direction
		private var holding:Boolean;
		private var playerState:String;
		private var playerAnim:MovieClip;
		private var isClipPlaying:Boolean;

		//constructor to initialise player
		//takes in a path to the player movie clip
		public function Player(url:String)
		{
			currentDirection = Constants.MOVE_DIR_UP;
			playerState = Constants.PLAYER_STATE_STOP;

			var loader:Loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completedExternalAssetLoad);
			isClipPlaying=false;
		}

		public function movePlayer(moveDirection:String)
		{
			if (playerState == Constants.PLAYER_STATE_MOVE)
			{
				if (moveDirection == Constants.MOVE_DIR_DOWN)
				{
					currentDirection = Constants.MOVE_DIR_DOWN;
					this.y +=  Constants.STEP_LENGTH;
				}
				else if (moveDirection == Constants.MOVE_DIR_RIGHT)
				{
					currentDirection = Constants.MOVE_DIR_RIGHT;
					this.scaleX = 1; 
					this.x +=  Constants.STEP_LENGTH;
				}
				else if (moveDirection == Constants.MOVE_DIR_LEFT)
				{
					currentDirection = Constants.MOVE_DIR_LEFT;
					this.scaleX = -1; //flip the movie clip
					this.x -=  Constants.STEP_LENGTH;
				}
				else if (moveDirection == Constants.MOVE_DIR_UP)
				{
					currentDirection = Constants.MOVE_DIR_UP;
					this.y -=  Constants.STEP_LENGTH;
				}
			}
			else if (playerState == Constants.PLAYER_STATE_STOP)
			{
				playerAnim.gotoAndStop("idle");
				isClipPlaying = false;
			}
			
			if(isClipPlaying == false && playerState == Constants.PLAYER_STATE_MOVE){
				playerAnim.gotoAndPlay("move");
				isClipPlaying = true;
			}
		}

		public function getCurrentDirection():String
		{
			return currentDirection;
		}

		public function setHolding(holding:Boolean)
		{
			this.holding = holding;
		}

		public function isHolding():Boolean
		{
			return holding;
		}

		public function resetPositions(xpos:uint,ypos:uint)
		{
			this.x = xpos;
			this.y = ypos;
		}

		public function setPlayerState(state:String)
		{
			playerState = state;
		}

		private function completedExternalAssetLoad(event:Event):void
		{
			playerAnim = event.target.content as MovieClip;
			playerAnim.scaleX = 2.5; //manually scaling the movieclip
			playerAnim.scaleY = 2.5;
			this.addChild(playerAnim);
			event.target.removeEventListener(Event.COMPLETE, this.completedExternalAssetLoad);
		}
	}
}