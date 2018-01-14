@IsTest
public class StringAssertTest {
    static Assert assert = Sf.assert.setUseCustomException(true);
    static String customMessage = 'Custom Message';
    
    public static void test_multiAssert() {
        Assert assert2 = Sf.assert.setUseCustomException(true).setMultiAssert(true);
        
        assert2.that('Today is a beautiful day')
            .isNotNull()
            .startsWith('Today')
            .endsWith('day')
            .contains('is a')
            ;
		
        try {
            assert2.that('Today is a beautiful day')
                .isNull()
                .startsWith('Today2')
                .endsWith('day2 ')
                .contains('is a2')
                .evaluate();
        } catch (Exception e) {
            assert2.that(e).getMessage().contains('is a2').contains('Today2');
        }
    }
    
    testmethod public static void test_isNull() {
        
        assert.that((String) null).isNull();
        
        try {
	        assert.that('foo').isNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to be [null] but is not');
        }

        assert.that((String) null).isNull(customMessage);
        
        try {
	        assert.that('foo').isNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isNotNull() {
        
        assert.that('foo').isNotNull();
        assert.that('').isNotNull();
        assert.that(' ').isNotNull();
        
        try {
	        assert.that((String) null).isNotNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        assert.that('foo').isNotNull(customMessage);
        assert.that('').isNotNull(customMessage);
        assert.that(' ').isNotNull(customMessage);
        
        try {
	        assert.that((String) null).isNotNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isEqualsTo() {
        
        assert.that('foo').isEqualsTo('foo');
        assert.that('').isEqualsTo('');
        assert.that(' ').isEqualsTo(' ');
        assert.that((String) null).isEqualsTo(null);
        
        try {
	        assert.that('foo').isEqualsTo('Foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to be equals to [Foo] but is not');
        }

        try {
	        assert.that('foo').isEqualsTo(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to be equals to [null] but is not');
        }
        try {
	        assert.that((String) null).isEqualsTo('foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be equals to [foo] but is not');
        }

        assert.that('foo').isEqualsTo('foo', customMessage);
        assert.that('').isEqualsTo('', customMessage);
        assert.that(' ').isEqualsTo(' ', customMessage);
        assert.that((String) null).isEqualsTo(null, customMessage);
        
        try {
	        assert.that('foo').isEqualsTo('Foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that('foo').isEqualsTo(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that((String) null).isEqualsTo('foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isEqualsToIgnoreCase() {
        
        assert.that('foo').ignoreCase().isEqualsTo('foo');
        assert.that('').ignoreCase().isEqualsTo('');
        assert.that(' ').ignoreCase().isEqualsTo(' ');
        assert.that((String) null).ignoreCase().isEqualsTo(null);
        assert.that('foo').ignoreCase().isEqualsTo('Foo');
        
        try {
	        assert.that('foo').ignoreCase().isEqualsTo(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to be equals to [null] (ignoring case) but is not');
        }
        try {
	        assert.that((String) null).ignoreCase().isEqualsTo('foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be equals to [foo] (ignoring case) but is not');
        }

        assert.that('foo').ignoreCase().isEqualsTo('foo', customMessage);
        assert.that('').ignoreCase().isEqualsTo('', customMessage);
        assert.that(' ').ignoreCase().isEqualsTo(' ', customMessage);
        assert.that((String) null).ignoreCase().isEqualsTo(null, customMessage);
        assert.that('foo').ignoreCase().isEqualsTo('Foo', customMessage);
        
        try {
	        assert.that('foo').ignoreCase().isEqualsTo(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that((String) null).ignoreCase().isEqualsTo('foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isNotEqualsTo() {
        
        assert.that('foo').isNotEqualsTo('Foo');
        assert.that(' ').isNotEqualsTo('');
        assert.that('').isNotEqualsTo(' ');
        assert.that((String) null).isNotEqualsTo(' ');
        assert.that('').isNotEqualsTo(null);
        
        try {
	        assert.that('foo').isNotEqualsTo('foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to be not equals to [Foo] but is');
        }
        
        try {
	        assert.that((String) null).isNotEqualsTo(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be not equals to [null] but is');
        }
        
        try {
	        assert.that(' ').isNotEqualsTo(' ');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [ ] to be not equals to [ ] but is');
        }

        try {
	        assert.that('').isNotEqualsTo('');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [] to be not equals to [] but is');
        }

        assert.that('foo').isNotEqualsTo('Foo', customMessage);
        assert.that(' ').isNotEqualsTo('', customMessage);
        assert.that('').isNotEqualsTo(' ', customMessage);
        assert.that((String) null).isNotEqualsTo(' ', customMessage);
        assert.that('').isNotEqualsTo(null, customMessage);
        
        try {
	        assert.that('foo').isNotEqualsTo('foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        try {
	        assert.that((String) null).isNotEqualsTo(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        try {
	        assert.that(' ').isNotEqualsTo(' ', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that('').isNotEqualsTo('', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }    
    
    testmethod public static void test_isNotEqualsToIgnoreCase() {
        
        assert.that(' ').ignoreCase().isNotEqualsTo('');
        assert.that('').ignoreCase().isNotEqualsTo(' ');
        assert.that((String) null).ignoreCase().isNotEqualsTo(' ');
        assert.that('').ignoreCase().isNotEqualsTo(null);
        
        try {
	        assert.that('foo').ignoreCase().isNotEqualsTo('Foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to be not equals to [Foo] (ignoring case) but is');
        }

        try {
	        assert.that('foo').ignoreCase().isNotEqualsTo('foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to be not equals to [Foo] (ignoring case) but is');
        }
        
        try {
	        assert.that((String) null).ignoreCase().isNotEqualsTo(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be not equals to [null] (ignoring case) but is');
        }
        
        try {
	        assert.that(' ').ignoreCase().isNotEqualsTo(' ');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [ ] to be not equals to [ ] (ignoring case) but is');
        }

        try {
	        assert.that('').ignoreCase().isNotEqualsTo('');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [] to be not equals to [] (ignoring case) but is');
        }
    }    
    
    testmethod public static void test_isSameAs() {
        assert.that('foo').isSameAs('foo');
        
        try {
	        assert.that('foo').isSameAs('Foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to be same as [Foo] but is not');
        }

        try {
            //When we do trim, it should create new string
	        assert.that('foo').isSameAs(' foo '.trim());
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to be same as [foo] but is not');
        }

        assert.that('foo').isSameAs('foo', customMessage);
        
        try {
	        assert.that('foo').isSameAs('Foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
            //When we do trim, it should create new string
	        assert.that('foo').isSameAs(' foo '.trim(), customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }    

    testmethod public static void test_isNotSameAs() {
        assert.that((String) null).isNotSameAs('Foo');
        assert.that('foo').isNotSameAs('Foo');
        assert.that('foo').isNotSameAs(null);
        assert.that('foo').isNotSameAs(' foo '.trim());
        
        try {
	        assert.that('foo').isNotSameAs('foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to be not same as [foo] but is');
        }

        assert.that((String) null).isNotSameAs('Foo', customMessage);
        assert.that('foo').isNotSameAs('Foo', customMessage);
        assert.that('foo').isNotSameAs(null, customMessage);
        assert.that('foo').isNotSameAs(' foo '.trim(), customMessage);
        
        try {
	        assert.that('foo').isNotSameAs('foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }    

    testmethod public static void test_isNullOrEmpty() {
        assert.that((String) null).isNullOrEmpty();
        assert.that('').isNullOrEmpty();
        
        try {
	        assert.that(' ').isNullOrEmpty();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [ ] to be either null or empty but is not');
        }

        assert.that((String) null).isNullOrEmpty(customMessage);
        assert.that('').isNullOrEmpty(customMessage);
        
        try {
	        assert.that(' ').isNullOrEmpty(customMessage);
            assert.expectedException(customMessage);
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }    

    testmethod public static void test_isEmpty() {
        assert.that('').isEmpty();
        
        try {
	        assert.that((String) null).isEmpty();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be empty but is not');
        }

        try {
	        assert.that(' ').isEmpty();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [ ] to be empty but is not');
        }

        assert.that('').isEmpty(customMessage);
        
        try {
	        assert.that((String) null).isEmpty(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that(' ').isEmpty(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

    }    


    testmethod public static void test_isNotEmpty() {
	    assert.that((String) null).isNotEmpty();
	    assert.that('foo').isNotEmpty();
	    assert.that(' ').isNotEmpty();
        
        try {
        	assert.that('').isNotEmpty();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [] to be not empty but is');
        }

	    assert.that((String) null).isNotEmpty(customMessage);
	    assert.that('foo').isNotEmpty(customMessage);
	    assert.that(' ').isNotEmpty(customMessage);
        
        try {
        	assert.that('').isNotEmpty(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

    }    
    
    testmethod public static void test_isNullOrBlank() {
        assert.that((String) null).isNullOrBlank();
        assert.that('').isNullOrBlank();
        assert.that(' ').isNullOrBlank();
        
        try {
	        assert.that('foo').isNullOrBlank();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to be either null or blank but is not');
        }

        assert.that((String) null).isNullOrBlank(customMessage);
        assert.that('').isNullOrBlank(customMessage);
        assert.that(' ').isNullOrBlank(customMessage);
        
        try {
	        assert.that('foo').isNullOrBlank(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }    
    
    testmethod public static void test_isBlank() {
        assert.that('').isBlank();
        assert.that(' ').isBlank();
        
        try {
	        assert.that((String) null).isBlank();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be blank but is not');
        }

        try {
	        assert.that('foo').isBlank();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to be blank but is not');
        }

        assert.that('').isBlank(customMessage);
        assert.that(' ').isBlank(customMessage);
        
        try {
	        assert.that((String) null).isBlank(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that('foo').isBlank(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }    
    
    testmethod public static void test_isNotBlank() {
	    assert.that((String) null).isNotBlank();
	    assert.that('foo').isNotBlank();
        
        try {
		    assert.that(' ').isNotBlank();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [ ] to be not blank but is');
        }

        try {
        	assert.that('').isNotBlank();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [] to be not blank but is');
        }

	    assert.that((String) null).isNotBlank(customMessage);
	    assert.that('foo').isNotBlank(customMessage);
        
        try {
		    assert.that(' ').isNotBlank(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
        	assert.that('').isNotBlank(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

    }    
    
    testmethod public static void test_hasSize() {
	    assert.that(' ').hasSize(1);
	    assert.that('foo').hasSize(3);
	    assert.that('foo\nbar').hasSize(7);
        
        try {
		    assert.that((String) null).hasSize(0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
		    assert.that('bar').hasSize(1);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [bar] to have size [1] but it has [3]');
        }

        assert.that(' ').hasSize(1, customMessage);
	    assert.that('foo').hasSize(3, customMessage);
	    assert.that('foo\nbar').hasSize(7, customMessage);
        
        try {
		    assert.that((String) null).hasSize(0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }
        
        try {
		    assert.that('bar').hasSize(1, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }    
    
    testmethod public static void test_hasLineCount() {
	    assert.that(' ').hasLineCount(1);
	    assert.that('foo').hasLineCount(1);
	    assert.that('foo\nbar').hasLineCount(2);
        
        try {
		    assert.that((String) null).hasLineCount(0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
		    assert.that('bar').hasLineCount(2);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [bar] to have [2] lines but it has [1]');
        }

	    assert.that(' ').hasLineCount(1, customMessage);
	    assert.that('foo').hasLineCount(1, customMessage);
	    assert.that('foo\nbar').hasLineCount(2, customMessage);
        
        try {
		    assert.that((String) null).hasLineCount(0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
		    assert.that('bar').hasLineCount(2, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }    

    testmethod public static void test_hasSameSizeAs() {
	    assert.that(' ').hasSameSizeAs(' ');
	    assert.that((String) null).hasSameSizeAs(null);
	    assert.that('foo').hasSameSizeAs('foo');
	    assert.that('foo\nbar').hasSameSizeAs('foo\nbar');
        
        try {
		    assert.that('foo').hasSameSizeAs('alice');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to have same size as [alice] but is not');
        }

        try {
		    assert.that((String) null).hasSameSizeAs('alice');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to have same size as [alice] but is not');
        }

        try {
		    assert.that('alice').hasSameSizeAs(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [alice] to have same size as [null] but is not');
        }
        
        assert.that(' ').hasSameSizeAs(' ', customMessage);
	    assert.that((String) null).hasSameSizeAs(null, customMessage);
	    assert.that('foo').hasSameSizeAs('foo', customMessage);
	    assert.that('foo\nbar').hasSameSizeAs('foo\nbar', customMessage);
        
        try {
		    assert.that('foo').hasSameSizeAs('alice', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
		    assert.that((String) null).hasSameSizeAs('alice', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
		    assert.that('alice').hasSameSizeAs(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }    
    
    testmethod public static void test_startsWith() {
        assert.that('foo').startsWith('foo');
        assert.that(' ').startsWith('');
        assert.that('Hello World').startsWith('Hello');
        
        try {
	        assert.that((String) null).startsWith(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').startsWith(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').startsWith('Foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to start with [Foo] but is not');
        }

        try {
	        assert.that('').startsWith(' ');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [] to start with [ ] but is not');
        }


        assert.that('foo').startsWith('foo', customMessage);
        assert.that(' ').startsWith('', customMessage);
        assert.that('Hello World').startsWith('Hello', customMessage);
        
        try {
	        assert.that((String) null).startsWith(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').startsWith(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').startsWith('Foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that('').startsWith(' ', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_doesNotStartWith() {
        assert.that('foo').doesNotStartWith('Foo');
        assert.that('').doesNotStartWith(' ');
        
        try {
	        assert.that((String) null).doesNotStartWith(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').startsWith(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').doesNotStartWith('foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to not start with [foo] but is');
        }

        try {
	        assert.that(' ').doesNotStartWith('');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [ ] to not start with [] but is');
        }

        try {
	        assert.that('Hello World').doesNotStartWith('Hello');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [Hello World] to not start with [Hello] but is');
        }

        assert.that('foo').doesNotStartWith('Foo', customMessage);
        assert.that('').doesNotStartWith(' ', customMessage);
        
        try {
	        assert.that((String) null).doesNotStartWith(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').startsWith(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').doesNotStartWith('foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that(' ').doesNotStartWith('', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that('Hello World').doesNotStartWith('Hello', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}
    
    testmethod public static void test_endsWith() {
        assert.that('foo').endsWith('foo');
        assert.that(' ').endsWith('');
        assert.that('Hello World').endsWith('World');
        
        try {
	        assert.that((String) null).endsWith(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').endsWith(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').endsWith('Foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to end with [Foo] but is not');
        }

        try {
	        assert.that('').endsWith(' ');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [] to end with [ ] but is not');
        }


        assert.that('foo').endsWith('foo', customMessage);
        assert.that(' ').endsWith('', customMessage);
        assert.that('Hello World').endsWith('World', customMessage);
        
        try {
	        assert.that((String) null).endsWith(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').endsWith(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').endsWith('Foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that('').endsWith(' ', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_endsWithIgnoreCase() {
        assert.that('foo').ignoreCase().endsWith('foo');
        assert.that('foo').ignoreCase().endsWith('Foo');
        assert.that('foo').ignoreCase().endsWith('FOO');
        assert.that(' ').ignoreCase().endsWith('');
        assert.that('Hello World').ignoreCase().endsWith('world');
        
        try {
	        assert.that((String) null).ignoreCase().endsWith(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').ignoreCase().endsWith(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').ignoreCase().endsWith('Bar');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to end with [Bar] (ignoring case) but is not');
        }

        try {
	        assert.that('').ignoreCase().endsWith(' ');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [] to end with [ ] (ignoring case) but is not');
        }

        assert.that('foo').ignoreCase().endsWith('Foo', customMessage);
        assert.that(' ').ignoreCase().endsWith('', customMessage);
        assert.that('Hello World').ignoreCase().endsWith('world', customMessage);
        
        try {
	        assert.that((String) null).ignoreCase().endsWith(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').ignoreCase().endsWith(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').ignoreCase().endsWith('Bar', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that('').ignoreCase().endsWith(' ', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_doesNotEndWith() {
        assert.that('foo').doesNotEndWith('Foo');
        assert.that('Hello World').doesNotEndWith('Hello');
        assert.that('').doesNotEndWith(' ');
        
        try {
	        assert.that((String) null).doesNotEndWith(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').doesNotEndWith(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').doesNotEndWith('foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to not end with [foo] but is');
        }

        try {
	        assert.that(' ').doesNotEndWith('');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [ ] to not end with [] but is');
        }

        try {
	        assert.that('Hello World').doesNotEndWith('World');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [Hello World] to not end with [World] but is');
        }

        assert.that('foo').doesNotEndWith('Foo', customMessage);
        assert.that('Hello World').doesNotEndWith('Hello', customMessage);
        assert.that('').doesNotEndWith(' ', customMessage);
        
        try {
	        assert.that((String) null).doesNotEndWith(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').doesNotEndWith(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').doesNotEndWith('foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that(' ').doesNotEndWith('', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that('Hello World').doesNotEndWith('World', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}
    
    testmethod public static void test_doesNotEndWithIgnoreCase() {
        try {
	        assert.that('foo').ignoreCase().doesNotEndWith('Foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to not end with [Foo] (ignoring case) but is');
        }

        assert.that('Hello World').ignoreCase().doesNotEndWith('Hello');
        assert.that('').ignoreCase().doesNotEndWith(' ');
        
        try {
	        assert.that((String) null).ignoreCase().doesNotEndWith(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').ignoreCase().doesNotEndWith(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').ignoreCase().doesNotEndWith('foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to not end with [foo] (ignoring case) but is');
        }

        try {
	        assert.that(' ').ignoreCase().doesNotEndWith('');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [ ] to not end with [] (ignoring case) but is');
        }

        try {
	        assert.that('Hello World').ignoreCase().doesNotEndWith('World');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [Hello World] to not end with [World] (ignoring case) but is');
        }

        try {
	        assert.that('foo').ignoreCase().doesNotEndWith('Foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        assert.that('Hello World').ignoreCase().doesNotEndWith('Hello', customMessage);
        assert.that('').doesNotEndWith(' ', customMessage);
        
        try {
	        assert.that((String) null).ignoreCase().doesNotEndWith(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').ignoreCase().doesNotEndWith(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').ignoreCase().doesNotEndWith('foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that(' ').ignoreCase().doesNotEndWith('', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that('Hello World').ignoreCase().doesNotEndWith('World', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}

    testmethod public static void test_contains() {
        assert.that('Interstate 96 (I-96) is an Interstate Highway')
            .contains('is an')
            .contains('(I-96)');
        assert.that(' ').contains('');
        
        try {
	        assert.that((String) null).contains(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').contains(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('Interstate 96 (I-96) is an Interstate Highway').contains('interstate highway');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [Interstate 96 (I-96) is an Interstate Highway] to contain [interstate highway] but is not');
        }

        assert.that(' ').contains('');

        assert.that('Interstate 96 (I-96) is an Interstate Highway')
            .contains('is an', customMessage)
            .contains('(I-96)', customMessage);
        assert.that(' ').contains('', customMessage);
        
        try {
	        assert.that((String) null).contains(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').contains(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('Interstate 96 (I-96) is an Interstate Highway').contains('Super Fast', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        assert.that(' ').contains('', customMessage);
   	}
    
    testmethod public static void test_containsIgnoreCase() {
        assert.that('Interstate 96 (I-96) is an Interstate Highway').ignoreCase()
            .contains('is an')
            .contains('(I-96)');
        assert.that(' ').contains('');
        
        try {
	        assert.that((String) null).ignoreCase().contains(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').ignoreCase().contains(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        assert.that('Interstate 96 (I-96) is an Interstate Highway').ignoreCase().contains('interstate highway');
        assert.that(' ').ignoreCase().contains('');

        assert.that('Interstate 96 (I-96) is an Interstate Highway').ignoreCase()
            .contains('is an', customMessage)
            .contains('(I-96)', customMessage);
        assert.that(' ').contains('', customMessage);
        
        try {
	        assert.that((String) null).ignoreCase().contains(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').ignoreCase().contains(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('Interstate 96 (I-96) is an Interstate Highway').ignoreCase().contains('Super Fast', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        assert.that(' ').ignoreCase().contains('', customMessage);
   	}
    
    testmethod public static void test_doesNotContain() {
        assert.that('foo').doesNotContain('Foo');
        assert.that('').doesNotContain(' ');
        
        try {
	        assert.that((String) null).doesNotContain(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').doesNotContain(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').doesNotContain('foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to not contain [foo] but is');
        }

        try {
	        assert.that(' ').doesNotContain('');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [ ] to not contain [] but is');
        }

        try {
	        assert.that('Hello World').doesNotContain('Hello');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [Hello World] to not contain [Hello] but is');
        }

        assert.that('foo').doesNotContain('Foo', customMessage);
        assert.that('').doesNotContain(' ', customMessage);
        
        try {
	        assert.that((String) null).doesNotContain(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        try {
	        assert.that('').doesNotContain(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that other parameter passed to assert with actual to be not [null] but is');
        }

        try {
	        assert.that('foo').doesNotContain('foo', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that(' ').doesNotContain('', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }

        try {
	        assert.that('Hello World').doesNotContain('Hello', customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}
    
   	testmethod public static void test_doesNotContainIgnoreCase() {
        try {
	        assert.that('foo').ignoreCase().doesNotContain('Foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to not contain [Foo] (ignoring case) but is');
        }

        try {
	        assert.that('foo').doesNotContain('foo');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [foo] to not contain [foo] but is');
        }

        try {
	        assert.that('Hello World').ignoreCase().doesNotContain('hello');
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [Hello World] to not contain [hello] (ignoring case) but is');
        }

   }
}