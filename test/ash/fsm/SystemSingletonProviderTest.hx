package ash.fsm;

import ash.core.System;
import ash.Mocks.EmptySystem;
import ash.Mocks.EmptySystem2;

import org.hamcrest.MatchersBase;

class SystemSingletonProviderTest extends MatchersBaseTestCase
{
    @Test
    public function testproviderReturnsAnInstanceOfSystem():Void
    {
        var provider:SystemSingletonProvider<EmptySystem> = new SystemSingletonProvider( EmptySystem );
        assertThat(provider.getSystem(), instanceOf(EmptySystem));
    }

    @Test
    public function testproviderReturnsSameInstanceEachTime():Void
    {
        var provider:SystemSingletonProvider<EmptySystem> = new SystemSingletonProvider( EmptySystem );
        assertThat(provider.getSystem(), equalTo(provider.getSystem()));
    }

    @Test
    public function testprovidersWithSameSystemHaveDifferentIdentifier():Void
    {
        var provider1:SystemSingletonProvider<EmptySystem> = new SystemSingletonProvider( EmptySystem );
        var provider2:SystemSingletonProvider<EmptySystem> = new SystemSingletonProvider( EmptySystem );
        assertThat(provider1.identifier, not(provider2.identifier));
    }

    @Test
    public function testprovidersWithDifferentSystemsHaveDifferentIdentifier():Void
    {
        var provider1:SystemSingletonProvider<EmptySystem> = new SystemSingletonProvider( EmptySystem );
        var provider2:SystemSingletonProvider<EmptySystem2> = new SystemSingletonProvider( EmptySystem2 );
        assertThat(provider1.identifier, not(provider2.identifier));
    }
}
