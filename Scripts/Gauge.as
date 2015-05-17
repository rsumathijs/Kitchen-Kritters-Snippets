package 
{
	import flash.display.MovieClip;

	//class that represents the score gauge
	public class Gauge extends MovieClip
	{
		private var gaugePointer:MovieClip;
		private var gaugeBar:MovieClip;
		private var gaugeLength:uint;
		private var gaugeValue;

		private const gaugeMax = Constants.SCORE_MAX;

		public function Gauge()
		{
			gaugePointer = pointer;
			gaugeBar = gaugebar;
			gaugeLength = gaugeBar.width;
		}

		public function updateGauge(value:int)
		{
			//if value is out of limits, reset it to the end value of the limits
			if (value < 0)
			{
				gaugeValue = 0;
			}
			else if (value > gaugeMax)
			{
				gaugeValue = gaugeMax;
			}
			else
			{
				gaugeValue = value;
			}

			//the gauge spindle represents a percentage of the maximum score, rather than the score itself
			//we use this to figure out how far the spindle should be on the bar
			gaugePointer.x = (gaugeValue * gaugeLength) / gaugeMax;
		}
	}
}