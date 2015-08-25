package {
	import flash.display.*;
	import flash.text.*;
	
	public class ScoreBox extends Sprite {

		var rectangle = new Sprite();
		var totalText:TextField = new TextField();
		var scoreText:TextField = new TextField();
		var timeBonusText:TextField = new TextField();

		var score = 0;
		var timeBonus = 0;
		
		public var scale:Number = 0.5;
				
		public function ScoreBox() {
			init();	
		}
		
		public function init() {
			initSprite();
		}
		
		public function initSprite()
		{
			rectangle.graphics.lineStyle(1, 0xCCCCCC);
			rectangle.graphics.drawRect(0, 0, 400, 20);
			rectangle.graphics.endFill();
			addChild(rectangle);
			
			totalText.textColor = 0x000000;
			totalText.autoSize = TextFieldAutoSize.LEFT;
			totalText.x = 260;
			totalText.y = 0;
			addChild(totalText);

			scoreText.textColor = 0x000000;
			scoreText.autoSize = TextFieldAutoSize.LEFT;
			scoreText.x = 130;
			scoreText.y = 0;
			addChild(scoreText);

			timeBonusText.textColor = 0xFF5555;
			timeBonusText.autoSize = TextFieldAutoSize.LEFT;
			timeBonusText.x = 5;
			timeBonusText.y = 0;
			addChild(timeBonusText);
			
			updateText();
		}
		
		public function incrementScore(amount)
		{
			this.score += amount;
			updateText();
		}

		public function decrementScore(amount)
		{
			this.score -= amount;
			updateText();
		}

		public function setScore(score)
		{
			this.score = score;
			updateText();
		}
		
		public function decrementTimeBonus(amount)
		{
			this.timeBonus -= amount;
			this.timeBonus = Math.max(0, this.timeBonus);
			updateText();
		}
		
		public function setTimeBonus(score)
		{
			this.timeBonus = score;
			updateText();
		}
		
		public function getTotalScore()
		{
			return score + timeBonus;
		}
		
		public function updateText()
		{
			totalText.text = "TOTAL: " + getTotalScore();
			scoreText.text = "SCORE: " + score;
			timeBonusText.text = "TIME BONUS: "+ timeBonus;
		}
	}
}