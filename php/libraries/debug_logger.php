<?php
############################################################################
#	debug_logger.php
#
#	07/03/2015
#	A debug logger to assist in collecting information to be displayed in the
#	debugging toolbar
#
############################################################################

/**
 * @usage:
 *	$logger = new DebugLogger();
 *
 *	$logger->log('I am a custom log entry');
 *	$logger->logQuery('SELECT * FROM whatever WHERE id = :id', array('id' => 1));
 *	$logger->getParameter('start_time');
 *	$logger->setParameter('end_time', microtime()));
 */
class DebugLogger
{

	protected $parameters = array();

	protected $logs = array();

	protected $queries = array();

	/**
	 * Constructor
	 *
	 * @param array $data
	 */
	public function __construct(array $parameters = array())
	{
		$this->parameters = array_merge_recursive($this->parameters, $parameters);
	}

	/**
	 * log
	 *
	 * Log a message to be displayed in the debug toolbar
	 *
	 * @param string $msg
	 * @return DebugLogger
	 */
	public function log($msg)
	{
		if(is_array($msg) || is_object($msg)){
			array_push($this->logs, print_r($msg,true));
		}else{
			array_push($this->logs, $msg);
		}
		return $this;
	}

	/**
	 * getLogCount
	 *
	 * Get the total number of logs
	 *
	 * @return number
	 */
	public function getLogCount()
	{
		return count($this->logs);
	}

	/**
	 * getLogs
	 *
	 * Get all the logs
	 *
	 * @return array
	 */
	public function getLogs()
	{
		return $this->logs;
	}

	/**
	 * getQueryCount
	 *
	 * Get the total number of queries logged
	 * @return number
	 */
	public function getQueryCount()
	{
		return count($this->queries);
	}

	/**
	 * getQueries
	 *
	 * Get all the logged queries
	 *
	 * @return array:
	 */
	public function getQueries()
	{
		return $this->queries;
	}

	/**
	 * logQuery
	 * @param unknown $query
	 * @param array $parameters
	 * @return DebugLogger
	 */
	public function logQuery($query, array $bindParameters = array())
	{
		array_push($this->queries, array(
			'query' 		 => $query,
			'bindParameters' => $bindParameters,
		));

		return $this;
	}

	/**
	 * setParameter
	 *
	 * @param unknown $param
	 * @param unknown $value
	 * @return DebugLogger
	 */
	public function setParameter($param, $value)
	{
		$this->parameters[$param] = $value;
		return $this;
	}

	/**
	 * getParameter
	 *
	 * @param string $param
	 * @throws \InvalidArgumentException
	 * @return mixed:
	 */
	public function getParameter($param)
	{
		if (!isset($this->parameters[$param])) {
			throw new \InvalidArgumentException(sprintf('Parameter named %s does not exist', $param));
		}

		return $this->parameters[$param];
	}
}

?>