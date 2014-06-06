package;


import shoo.hxdet.Position;
import shoo.hxdet.GeomUtils;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.display.CapsStyle;
import flash.display.LineScaleMode;
import flash.events.Event;
import shoo.hxdet.DungeonCollisionDetector;
import flash.display.Sprite;


class Main extends Sprite {
	var staticCollisionDetector:DungeonCollisionDetector = {new DungeonCollisionDetector();};
	var rayCanvas:Sprite = {new Sprite();};
	var origin:Point = {new Point();};
	var marker:Sprite;

	inline static var NUM_CORRIDORS:Int = 5;

	public function new() {
		super();
		var center = Position.fromXY(stage.stageWidth/2, stage.stageHeight/2);
		addCircle(center.x, center.y, 50);
		for (i in 0...NUM_CORRIDORS) {
			var angle = i * 2 *Math.PI / NUM_CORRIDORS;
			var target = Point.polar(200, angle);
			target.offset(center.x, center.y);
			addCorridor(center.x, center.y, target.x, target.y, 30);
			addCircle( target.x, target.y, 50);
		}

		marker = getMarker();
		addChild(marker);
		addChild(rayCanvas);
		changeOrigin(center.x, center.y);

		marker.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		stage.addEventListener(MouseEvent.CLICK, clickHandler);
	}

	private function clickHandler(e:MouseEvent):Void {
		changeOrigin(stage.mouseX, stage.mouseY);
	}

	private function changeOrigin(x, y):Void {
		origin.x = x;
		origin.y = y;
		marker.x = x;
		marker.y = y;
	}

	private function enterFrameHandler(e:Event):Void {
		var marker:Sprite = e.target;
		var pos = staticCollisionDetector.getPosition(marker.x, marker.y, stage.mouseX, stage.mouseY);

		if (GeomUtils.distanceBetween(pos.x, pos.y, marker.x, marker.y) > GeomUtils.distanceBetween(stage.mouseX, stage.mouseY, marker.x, marker.y)) {
			marker.alpha = 1;
			marker.x = stage.mouseX;
			marker.y = stage.mouseY;
		} else {
			marker.alpha = 0.5;
			marker.x = pos.x;
			marker.y = pos.y;
		}
		renderRays();
	}

	private function renderRays():Void {
		var trg = staticCollisionDetector.getPosition(origin.x, origin.y, stage.mouseX, stage.mouseY);
		rayCanvas.graphics.clear();
		rayCanvas.graphics.lineStyle(3, 0x404090, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE);
		rayCanvas.graphics.moveTo(origin.x, origin.y);
		rayCanvas.graphics.lineTo(trg.x, trg.y);
		rayCanvas.graphics.lineStyle(1, 0x904040, 0.5, false, LineScaleMode.NORMAL, CapsStyle.NONE);
		rayCanvas.graphics.moveTo(origin.x, origin.y);
		rayCanvas.graphics.lineTo(stage.mouseX, stage.mouseY);
	}

	private function getMarker():Sprite {
		var marker = new Sprite();
		marker.graphics.beginFill(0xc0c0c0);
		marker.graphics.drawCircle(0, 0, 10);
		marker.graphics.endFill();
		return marker;
	}

	private function addCircle(x:Float, y:Float, r:Float):Void {
		staticCollisionDetector.addAllowedCircle(x, y, r);
		graphics.beginFill(0x404040);
		graphics.lineStyle(0, 0, 0);
		graphics.drawCircle(x, y, r);
		graphics.endFill();
	}

	private function addCorridor(x:Float, y:Float, x2:Float, y2:Float, width:Float):Void {
		staticCollisionDetector.addAllowedCorridor(x, y, x2, y2, width);
		graphics.lineStyle(width, 0x404040, 1, false);
		graphics.moveTo(x, y);
		graphics.lineTo(x2, y2);
	}


}