var data = [
{name: "service-in-scala", health: "health"},
{name: "service-in-java", health: "health"}
];

var ServiceBox = React.createClass({
  render: function() {
            return (
              <div className="serviceBox">
              <ServiceList data={this.props.data} />
              </div>
              );
          }
});

var ServiceList = React.createClass({
  render: function() {
            var serviceNodes = this.props.data.map(function(service) {
                    return (
                              <Service health={service.author} key={service.name}>
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

var Service = React.createClass({
   rawMarkup: function() {
                    var rawMarkup = marked(this.props.children.toString(), {sanitize: true});
                        return { __html: rawMarkup };
                          },

  render: function() {
            return (
              <div className="service">
              <h2 className="servicehealth">
              {this.props.health}
              </h2>
               <span dangerouslySetInnerHTML={this.rawMarkup()} />
              </div>
              );
          }
});

ReactDOM.render(
     <ServiceBox url="/status" />,
    document.getElementById('content')
    );
