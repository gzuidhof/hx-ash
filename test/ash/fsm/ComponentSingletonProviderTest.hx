package ash.fsm;

import org.hamcrest.MatchersBase;

import ash.fsm.ComponentSingletonProvider;
import ash.Mocks;

class ComponentSingletonProviderTest extends MatchersBaseTestCase
{
    @Test
    public function testProviderReturnsAnInstanceOfType():Void
    {
        var provider:ComponentSingletonProvider<MockComponent> = new ComponentSingletonProvider( MockComponent );
        assertThat(provider.getComponent(), any(MockComponent));
    }

    @Test
    public function testproviderReturnsSameInstanceEachTime():Void
    {
        var provider:ComponentSingletonProvider<MockComponent> = new ComponentSingletonProvider( MockComponent );
        assertThat(provider.getComponent(), equalTo(provider.getComponent()));
    }

    @Test
    public function testprovidersWithSameTypeHaveDifferentIdentifier():Void
    {
        var provider1:ComponentSingletonProvider<MockComponent> = new ComponentSingletonProvider( MockComponent );
        var provider2:ComponentSingletonProvider<MockComponent> = new ComponentSingletonProvider( MockComponent );
        assertThat(provider1.identifier, not(provider2.identifier));
    }

    @Test
    public function testprovidersWithDifferentTypeHaveDifferentIdentifier():Void
    {
        var provider1:ComponentSingletonProvider<MockComponent> = new ComponentSingletonProvider( MockComponent );
        var provider2:ComponentSingletonProvider<MockComponent2> = new ComponentSingletonProvider( MockComponent2 );
        assertThat(provider1.identifier, not(provider2.identifier));
    }
}
