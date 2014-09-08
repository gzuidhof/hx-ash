package ash.fsm;

import ash.core.System;

import org.hamcrest.MatchersBase;

class SystemInstanceProviderTest extends MatchersBaseTestCase
{
    @Test
    public function testproviderReturnsTheInstance():Void
    {
        var instance:MockSystem = new MockSystem();
        var provider:SystemInstanceProvider<MockSystem> = new SystemInstanceProvider( instance );
        assertThat(provider.getSystem(), sameInstance(instance));
    }

    @Test
    public function testprovidersWithSameInstanceHaveSameIdentifier():Void
    {
        var instance:MockSystem = new MockSystem();
        var provider1:SystemInstanceProvider<MockSystem> = new SystemInstanceProvider( instance );
        var provider2:SystemInstanceProvider<MockSystem> = new SystemInstanceProvider( instance );
        assertThat(provider1.identifier, equalTo(provider2.identifier));
    }

    @Test
    public function testprovidersWithDifferentInstanceHaveDifferentIdentifier():Void
    {
        var provider1:SystemInstanceProvider<MockSystem> = new SystemInstanceProvider( new MockSystem() );
        var provider2:SystemInstanceProvider<MockSystem> = new SystemInstanceProvider( new MockSystem() );
        assertThat(provider1.identifier, not(provider2.identifier));
    }
}

class MockSystem extends System
{
    public var value:Int;
}
