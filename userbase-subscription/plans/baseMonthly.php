<?
  class baseMonthly extends Plan {
  
    private $schedule;
  
    public function __construct($date = NULL) {
      $this->title = "Basic Monthly Plan";
      $this->description = "Description of Basic Monthly Plan";
      $this->planName = "Basic Monthly";
      $this->detailURL = "/plans/monthly.php";

      if(!isset($date) || $date == NULL) 
        $date = new DateTime;
      $start = $date->format("U");
      $date = $start;
      $this->schedule = array();
      while($date - $start < Plan::horizon * 86400) {
        array_push($this->schedule,new billingEvent(new DateTime("@$date")));
        $date += 86400 * 30;
      }
    }

    public function cronCallback() {}

    public function getSchedule() {
      return $this->schedule;
    }

  }
?>
