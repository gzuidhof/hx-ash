package ash.fsm;

import org.hamcrest.MatchersBase;

import ash.fsm.ComponentTypeProvider;
import ash.Mocks;

class ComponentTypeProviderTest extends MatchersBaseTestCase
{
    @Test
    public function testproviderReturnsAnInstanceOfType():Void
    {
        var provider:ComponentTypeProvider<MockComponent> = new ComponentTypeProvider( MockComponent );
        assertThat(provider.getComponent(), any(MockComponent));
    }

    @Test
    public function testproviderReturnsNewInstanceEachTime():Void
    {
        var provider:ComponentTypeProvider<MockComponent> = new ComponentTypeProvider( MockComponent );
        assertThat(provider.getComponent(), not(provider.getComponent()));
    }

    @Test
    public function testprovidersWithSameTypeHaveSameIdentifier():Void
    {
        var provider1:ComponentTypeProvider<MockComponent> = new ComponentTypeProvider( MockComponent );
        var provider2:ComponentTypeProvider<MockComponent> = new ComponentTypeProvider( MockComponent );
        assertThat(provider1.identifier, equalTo(provider2.identifier));
    }

    @Test
    public function testprovidersWithDifferentTypeHaveDifferentIdentifier():Void
    {
        var provider1:ComponentTypeProvider<MockComponent> = new ComponentTypeProvider( MockComponent );
        var provider2:ComponentTypeProvider<MockComponent2> = new ComponentTypeProvider( MockComponent2 );
        assertThat(provider1.identifier, not(provider2.identifier));
    }
}
