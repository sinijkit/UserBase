<?
  abstract class Plan {
  
    const horizon = 3650; // Schedule horizon in days
    
    public $title;
    public $description;
    public $detailURL;
    public $planName;
    
    abstract function cronCallback();
    abstract function getSchedule();
    
  }
  
  class billingEvent {

    public $billed;
    public $datetime;
      
    public function __construct($datetime) {
      $this->billed = FALSE;
      if(!isset($datetime))
        $datetime = new DateTime;
      $this->datetime = $datetime;
    }
  }
  
  class PlanMgmt {
  
    private $plans;
    
    public function __construct($planDir) {
    
      if(!is_dir($planDir))
        throw new Exception("$planDir: not a directory");
      if(! $dh = opendir($planDir))
        throw new Exception("Can't open directory $planDir");
      $this->plans = array();
      while($f = readdir($dh)) {
        if(!preg_match("/^[^\.].*\.php$/",$f)) continue;
        require_once("$planDir/$f");
        $c = preg_replace("/\.php$/","",$f);
        $p = new $c;
        array_push($this->plans,$p);
      }
      closedir($dh);
    }
    
    public function getPlans() {
      return($this->plans);
    }
  }
    
      
?>    
