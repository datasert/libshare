@IsTest
public class LoggerTest {
	static Assert assert = Sf.assert;
    
    testmethod public static void test_formatMessage() {
    	Logger logger = new Logger('test');
        assert.that(logger.formatMessage(null, null)).isEqualsTo('test: null');
        assert.that(logger.formatMessage('test', null)).isEqualsTo('test: test');
        assert.that(logger.formatMessage(10, null)).isEqualsTo('test: 10');
        assert.that(logger.formatMessage('Hello {0}', new String[]{'World'})).isEqualsTo('test: Hello World');
    }
    
    testmethod public static void test_variousLogMethods() {
        Logger logger = new Logger('test');
        
    	logger.error('msg');
    	logger.error('msg', 'arg1');
    	logger.error('msg', 'arg1', 'arg2');
    	logger.error('msg', 'arg1', 'arg2', 'arg3');
        logger.error('msg', new String[]{'arg1', 'arg2', 'arg3'});

        logger.warn('msg');
    	logger.warn('msg', 'arg1');
    	logger.warn('msg', 'arg1', 'arg2');
    	logger.warn('msg', 'arg1', 'arg2', 'arg3');
        logger.warn('msg', new String[]{'arg1', 'arg2', 'arg3'});

    	logger.info('msg');
    	logger.info('msg', 'arg1');
    	logger.info('msg', 'arg1', 'arg2');
    	logger.info('msg', 'arg1', 'arg2', 'arg3');
        logger.info('msg', new String[]{'arg1', 'arg2', 'arg3'});

        logger.debug('msg');
    	logger.debug('msg', 'arg1');
    	logger.debug('msg', 'arg1', 'arg2');
    	logger.debug('msg', 'arg1', 'arg2', 'arg3');
        logger.debug('msg', new String[]{'arg1', 'arg2', 'arg3'});
    }
}