var data = [
{name: "service-in-scala", health: "health"},
{name: "service-in-java", health: "health"}
];

var ServiceBox = React.createClass({
  loadServiceStatusFromServer: function() {
                                 $.ajax({
                                   url: this.props.url,
                                   dataType: 'json',
                                   cache: false,
                                   success: function(data) {
                                     this.setState({data: data});
                                   }.bind(this),
                                   error: function(xhr, status, err) {
                                            console.error(this.props.url, status, err.toString());
                                          }.bind(this)
                                 });
                               },
    getInitialState: function() {
                       return {data: []};
                     },
    componentDidMount: function() {
                         this.loadServiceStatusFromServer();
                         setInterval(this.loadServiceStatusFromServer, this.props.pollInterval);
                       },
    render: function() {
              return (
                  <div className="serviceBox">
                  <ServiceList data={this.state.data} />
                  </div>
                  );
            }
});

var Service = React.createClass({
  rawMarkup: function() {
               var rawMarkup = marked(this.props.children.toString(), {sanitize: true});
               return { __html: rawMarkup };
             },

    render: function() {
              return (
                <div className={this.props.health}>
                <h2 className="service">
                {this.props.name}
                </h2>
                </div>
                );
            }
});

var ServiceList = React.createClass({
  render: function() {
            var serviceNodes = this.props.data.map(function(service) {
              return (
                <Service health={service.health} key={service.name} name={service.name}>>
                {service.name}
                {service.health}
                </Service>
                );
            });
            return (
              <div className="serviceList">
              {serviceNodes}
              </div>
              );
          }
});


ReactDOM.render(
    <ServiceBox url="/status" pollInterval={2000} />,
    document.getElementById('content')
    );
