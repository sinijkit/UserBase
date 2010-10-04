<?
  class baseYearly extends Plan {
  
		private $schedule;

    public function __construct() {
      $this->title = "Basic Yearly Plan";
      $this->description = "Description of Basic Yearly Plan";
      $this->planName = "Basic Yearly";
      $this->detailURL = "/plans/yearly.php";

     if(!isset($date) || $date == NULL)
        $date = new DateTime;
      $start = $date->format("U"); 
      $date = $start;
      $this->schedule = array();
      while($date - $start < Plan::horizon * 86400) {
        array_push($this->schedule,new billingEvent(new DateTime("@$date")));
        $date += 86400 * 365;
      }

    }
    public function cronCallback() {}
    public function getSchedule() {
      return $this->schedule;
		}
  }
?>
