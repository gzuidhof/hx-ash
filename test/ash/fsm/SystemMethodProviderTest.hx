package ash.fsm;

import ash.core.System;
import ash.fsm.DynamicSystemProvider.DynamicSystemProviderClosure;
import ash.Mocks.EmptySystem;

import org.hamcrest.MatchersBase;

class SystemMethodProviderTest extends MatchersBaseTestCase
{
    @Test
    public function testproviderReturnsTheInstance():Void
    {
        var instance:EmptySystem = new EmptySystem();
        var providerMethod:DynamicSystemProviderClosure<EmptySystem> = function():EmptySystem
        {
            return instance;
        }

        var provider:DynamicSystemProvider<EmptySystem> = new DynamicSystemProvider( providerMethod );
        assertThat(provider.getSystem(), sameInstance(instance));
    }

    @Test
    public function testprovidersWithSameMethodHaveSameIdentifier():Void
    {
        var instance:EmptySystem = new EmptySystem();
        var providerMethod:DynamicSystemProviderClosure<EmptySystem> = function():EmptySystem
        {
            return instance;
        }
        var provider1:DynamicSystemProvider<EmptySystem> = new DynamicSystemProvider( providerMethod );
        var provider2:DynamicSystemProvider<EmptySystem> = new DynamicSystemProvider( providerMethod );
        assertThat(provider1.identifier, sameInstance(provider2.identifier));
    }

    @Test
    public function testprovidersWithDifferentMethodHaveDifferentIdentifier():Void
    {
        var instance:EmptySystem = new EmptySystem();
        var providerMethod1:DynamicSystemProviderClosure<EmptySystem> = function():EmptySystem
        {
            return instance;
        }

        var providerMethod2:DynamicSystemProviderClosure<EmptySystem> = function():EmptySystem
        {
            return instance;
        }

        var provider1:DynamicSystemProvider<EmptySystem> = new DynamicSystemProvider( providerMethod1 );
        var provider2:DynamicSystemProvider<EmptySystem> = new DynamicSystemProvider( providerMethod2 );
        assertThat(provider1.identifier, not(provider2.identifier));
    }
}
