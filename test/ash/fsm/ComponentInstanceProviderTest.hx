package ash.fsm;

import org.hamcrest.MatchersBase;

import ash.fsm.ComponentInstanceProvider;
import ash.Mocks;

class ComponentInstanceProviderTest extends MatchersBaseTestCase
{
    @Test
    public function testproviderReturnsTheInstance():Void
    {
        var instance:MockComponent = new MockComponent();
        var provider:ComponentInstanceProvider<MockComponent> = new ComponentInstanceProvider( instance );
        assertThat(provider.getComponent(), sameInstance(instance));
    }

    @Test
    public function testprovidersWithSameInstanceHaveSameIdentifier():Void
    {
        var instance:MockComponent = new MockComponent();
        var provider1:ComponentInstanceProvider<MockComponent> = new ComponentInstanceProvider( instance );
        var provider2:ComponentInstanceProvider<MockComponent> = new ComponentInstanceProvider( instance );
        assertThat(provider1.identifier, equalTo(provider2.identifier));
    }

    @Test
    public function testprovidersWithDifferentInstanceHaveDifferentIdentifier():Void
    {
        var provider1:ComponentInstanceProvider<MockComponent> = new ComponentInstanceProvider( new MockComponent() );
        var provider2:ComponentInstanceProvider<MockComponent> = new ComponentInstanceProvider( new MockComponent() );
        assertThat(provider1.identifier, not(provider2.identifier));
    }
}
