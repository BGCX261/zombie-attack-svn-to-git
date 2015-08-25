package {
	import gameitems.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.media.*;
	import flash.net.*;
	
	public class ZombieAttack extends MovieClip 
	{
		//game state
		private var room:Room;
		private var list:ItemList;
		public static var scoreBox:ScoreBox;
		private var gameTimer:Timer;
		private var clockSpeed = 20;
		private var gameOver = true;
		private var timeBonusCounter = 0;
		private var finalScoreText:TextField = new TextField();
		private var gameOverText:TextField = new TextField();
		private var gameOverText2:TextField = new TextField();
		private var restartButton:TextField = new TextField();
		private var boom:MovieClip = new BoomMovie();
		
		public function ZombieAttack() 
		{			
			init();
			main();
		}
		
		public function init() 
		{			
			list = new ItemList();
			addChild(list);
			room = new Room();
			addChild(room);
			
			scoreBox = new ScoreBox();
			scoreBox.x = (room.x + room.width) - (scoreBox.width + 2);
			scoreBox.y = (room.y + room.height) - (scoreBox.height + 2);
			addChild(scoreBox);
			
			this.gameTimer = new Timer(this.clockSpeed);
			gameTimer.addEventListener(TimerEvent.TIMER, step);
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
			room.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
			stage.stageFocusRect = false;
			stage.focus = room;			
		}
		
		public function main() 
		{			
			restartGame();
		}
		
		public function stopGame()
		{
			gameOver = true;			
			gameTimer.stop();			
			room.clearContents();
			
			list.reset();
			
			boom.x = room.x;
			boom.y = room.y;
			boom.width = room.width;
			boom.height = room.height - 50;
			
			this.addChild(boom);
			
			boom.gotoAndPlay(1);

			var format = new TextFormat();
			format.size = 64;
			gameOverText.text = gameOverText2.text = "GAME OVER!";
			gameOverText.textColor = 0xFFFFFF;
			gameOverText2.textColor = 0x00000;
			gameOverText.setTextFormat(format);
			gameOverText2.setTextFormat(format);
			gameOverText.autoSize = TextFieldAutoSize.CENTER;
			gameOverText2.autoSize = TextFieldAutoSize.CENTER;
			gameOverText.x = room.x + (room.rectangle.width / 2) - (gameOverText.width / 2);
			gameOverText.y = room.y + (room.rectangle.height / 2) - (gameOverText.height / 2);
			gameOverText2.x = gameOverText.x - 2;
			gameOverText2.y = gameOverText.y - 2;

			format.size = 20;
			finalScoreText.text = "SCORE: "+scoreBox.getTotalScore();
			finalScoreText.textColor = 0xFFFFFF;
			finalScoreText.setTextFormat(format);
			finalScoreText.autoSize = TextFieldAutoSize.CENTER;
			finalScoreText.x = room.x + (room.rectangle.width / 2) - (finalScoreText.width / 2);
			finalScoreText.y = room.y + (room.rectangle.height / 2) - (finalScoreText.height / 2) + 50;				
			
			restartButton.text = "MMMMOOOORRRRREEE!";
			restartButton.textColor = 0xFFFFFF;
			format.size = 18;
			restartButton.setTextFormat(format);
			restartButton.autoSize = TextFieldAutoSize.CENTER;
			restartButton.border = true;
			restartButton.borderColor = 0xFFFFFF;
			restartButton.background = true;
			restartButton.backgroundColor = 0x000000;
			restartButton.selectable = false;
			restartButton.x = room.x + (room.rectangle.width / 2) - (restartButton.width / 2);
			restartButton.y = (room.y + (room.rectangle.height / 2) - (restartButton.height / 2)) + 80;
			restartButton.addEventListener(MouseEvent.CLICK, restartButtonClick);
		
			this.addChild(restartButton);				
			this.addChild(finalScoreText);
			this.addChild(gameOverText2);
			this.addChild(gameOverText);
		}

		public function restartGame()
		{
			if(this.contains(gameOverText))
			{
				this.removeChild(gameOverText);
			}
			if(this.contains(gameOverText2))
			{
				this.removeChild(gameOverText2);
			}
			if(this.contains(finalScoreText))
			{
				this.removeChild(finalScoreText);
			}
			if(this.contains(restartButton))
			{
				this.removeChild(restartButton);
			}
			if(this.contains(boom))
			{
				this.removeChild(boom);
				//boom.gotoAndStop(1);
			}
			
			timeBonusCounter = 0;
			scoreBox.setScore(0);
			scoreBox.setTimeBonus(20000);			
			addRandomCharacters();
			gameOver = false;
			
			list.start();
			gameTimer.start();
		}
		
		// send a 'step' event to all NPCs
		private function step(event:TimerEvent)
		{
			var i:int;
			var s:Sprite;
			var sprites = new Array();
			room.proximityManager.refresh();

			// TMP
			/*var g:Graphics = room.graphics;
			g.clear();
			g.lineStyle(2,0xBBBBBB,1);*/
			// END TMP
			
			if (!gameOver)
			{
				timeBonusCounter++;
			
				if (timeBonusCounter >= 1)
				{
					timeBonusCounter = 0;
					scoreBox.decrementTimeBonus(1);
				}
			}
			
			for (i = 0; i < room.numChildren; i++)
			{
				s = room.getChildAt(i) as Sprite;
				if (s is NPC)
				{
					var npc:NPC = s as NPC;
					if (npc.isAlive)
					{
						npc.step(event);
					}
					
					// TMP DISPLAY CONNECTIONS
					/*var neighbours:Array = room.proximityManager.getNeighbors(s);
					var l:uint = neighbours.length;
					//trace("Neighbors: "+l);//TMP
					
					for (var j:uint=0; j<l; j++)
					{
						var neighbour:DisplayObject = neighbours[j] as DisplayObject;
							g.moveTo(s.x, s.y);
							g.lineTo(neighbour.x, neighbour.y);
					}*/
					// END TMP
				}
				else if (s is Noise)
				{
					var n:Noise = s as Noise;
					n.step(event);
				}
			}
			for (i = 0; i < room.numChildren; i++)
			{
				s = room.getChildAt(i) as Sprite;
				sprites.push(s);
			}			
			sprites.sort(sortOnYaxis);
			for (i = 0; i < sprites.length; i++)
			{
				if (sprites[i] != null)
				{
					room.setChildIndex(sprites[i], i);
					if (sprites[i] is NPC || sprites[i] is AGameItem)
					{
						var scale = 0.2 + (sprites[i].y / (room.height * 2));
						scale = Math.round(scale*1000) / 1000;
						sprites[i].scaleX = sprites[i].scaleY = scale;
					}
				}
			}
			checkGameState(event);
		}
		
		function sortOnYaxis(a:Sprite, b:Sprite):Number
		{
			if(a.y > b.y) {
				return 1;
			} else if(a.y < b.y) {
				return -1;
			} else  {
				return 0;
			}
		}			

		public function addRandomCharacters()
		{
			for (i = 0; i < 15; i++)
			{
				var survivor = new Survivor();
				survivor.x = Math.random() * 800 + 50;
				survivor.y = Math.random() * 600 + 50;
				survivor.npcName = "Survivor #"+i;
				
//				var item = list.factory.getItem();
//				room.add(item);
//				item.takeItem(survivor);
				
				room.add(survivor);
			}
			for (var i:Number = 0; i < 30; i++)
			{
				var zombie = new Zombie();
				zombie.setDirection(Math.random() * 360);
				zombie.x = Math.random() * 800 + 50;
				zombie.y = Math.random() * 600 + 50;
				zombie.npcName = "Zombie #"+i;
				room.add(zombie);
			}
		}
		
		public function checkGameState(event)
		{
			var gameEnd = false;
			
			var survivorCount = 0;
			var zombieCount = 0;
			
			for (var i = 0; i < room.numChildren; i++)
			{
				var s:Sprite = room.getChildAt(i) as Sprite;
				
				if (s is NPC)
				{
					var npc:NPC = s as NPC;
					if (npc.isAlive)
					{
						if(npc is Survivor)
						{
							survivorCount++;
						}
						else if (npc is Zombie)
						{
							zombieCount++;
						}
					}
				}
			}
			
			if(survivorCount==0 || zombieCount==0)
			{
				gameEnd = true;
			}
			
			if (gameEnd) // display game over text
			{
				trace("GAME OVER");//TMP
				
				this.stopGame();				
			}
		}
		
		private function restartButtonClick(e:MouseEvent) {
            restartGame();
        }

		private function keyHandler(event:KeyboardEvent)
		{
			var letter = String.fromCharCode(event.charCode);
			trace("key pressed: "+letter);//TMP
			switch (letter)
			{
				case 'd' :
					stopGame();
					break;
				case 'g' :
					stopGame();
					restartGame();
					break;
				default :
					break;
			}
		}
		
		public function clickHandler(event)
		{
			stage.focus = room;			
			
			if (event.ctrlKey)
			{
				var noise = new Noise();
				noise.x = stage.mouseX - room.x;
				noise.y = stage.mouseY;
				room.add(noise);			
			}
			else
			{			
				var gameItem = list.getNextItem();
				if (gameItem)
				{
					gameItem.setRoom(room);
					gameItem.x = stage.mouseX - room.x;
					gameItem.y = stage.mouseY;
					room.add(gameItem);
				}
			}
		}
				
	}
}