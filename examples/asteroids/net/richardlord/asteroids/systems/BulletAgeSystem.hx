package net.richardlord.asteroids.systems;

import ash.tools.ListIteratingSystem;

import net.richardlord.asteroids.EntityCreator;
import net.richardlord.asteroids.components.Bullet;
import net.richardlord.asteroids.nodes.BulletAgeNode;

class BulletAgeSystem extends ListIteratingSystem<BulletAgeNode>
{
    private var creator:EntityCreator;

    public function new(creator:EntityCreator)
    {
        super(BulletAgeNode, updateNode);
        this.creator = creator;
    }

    private function updateNode(node:BulletAgeNode, time:Float):Void
    {
        var bullet:Bullet = node.bullet;
        bullet.lifeRemaining -= time;
        if (bullet.lifeRemaining <= 0)
            creator.destroyEntity(node.entity);
    }
}
