package;

import kha.graphics2.Graphics;

typedef Vec2 = {
	x: Float,
	y: Float
};

typedef Body = {
	angle: Float,
	speed: Float,
	remote: Float,
	targetPos: Vec2,
	pos: Vec2
};

class Bullets {

	static final center: Vec2 = {x: 320, y: 240};
	static var target: Body;
	static var bullets: Array<Body> = [];

	public static function onInit(): Void {
		target = {
			angle: 0,
			speed: 0.002,
			remote: 160,
			targetPos: {x: 0, y: 0},
			pos: {x: 0, y: 0}
		};
	}

	static function getTargetPos(angle: Float): Vec2 {
		return {
			x: center.x + Math.cos(angle) * target.remote,
			y: center.y + Math.sin(angle) * target.remote
		};
	}

	public static function onMouseDown(button: Int, x: Int, y: Int): Void {
		if (button == 0)
			bullets.push({
				angle: 0,
				speed: 0.4,
				remote: 0, // не используется для пуль
				targetPos: {x: 0, y: 0},
				pos: {x: x, y: y}
			});
		else bullets.resize(0);
	}

	public static function onUpdate(): Void {
		target.angle += target.speed;
		target.pos = getTargetPos(target.angle);

		final forRemove = [];
		for (bullet in bullets) {
			final _vecX = target.pos.x - bullet.pos.x;
			final _vecY = target.pos.y - bullet.pos.y;
			final distance = Math.sqrt(Math.pow(_vecX, 2) + Math.pow(_vecY, 2));
			final adaptiveAngle = target.angle + target.speed * (distance / bullet.speed);
			final adaptiveTarget = getTargetPos(adaptiveAngle);
			bullet.targetPos = adaptiveTarget;

			final vecX = adaptiveTarget.x - bullet.pos.x;
			final vecY = adaptiveTarget.y - bullet.pos.y;
			if (Math.abs(vecX) < bullet.speed
			&& Math.abs(vecY) < bullet.speed) {
				forRemove.push(bullet);
			} else {
				bullet.angle = Math.atan2(vecY, vecX);
				bullet.pos.x += Math.cos(bullet.angle) * bullet.speed;
				bullet.pos.y += Math.sin(bullet.angle) * bullet.speed;
			}
		}
		for (bullet in forRemove) bullets.remove(bullet);
	}

	public static function onRender(g: Graphics): Void {
		g.color = 0xFFFFFFFF;
		for (bullet in bullets)
			g.drawLine(bullet.pos.x, bullet.pos.y, bullet.targetPos.x, bullet.targetPos.y);
		g.color = 0xFFFFD700;
		g.fillRect(target.pos.x - 2, target.pos.y - 2, 4, 4);

		g.color = 0xFFFF0000;
		for (bullet in bullets)
			g.fillRect(bullet.pos.x - 2, bullet.pos.y - 2, 4, 4);

		g.color = 0xFFFFFFFF;
		g.drawString("LMB - spawn, RMB - delete all", 4, 2);
	}
}
