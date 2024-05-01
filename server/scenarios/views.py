from django.http import HttpResponse
from django.template import loader
from .models import Scenario
from executions import execution


def scenarios(request):
    scn = Scenario.objects.filter(name="Alpha Test")
    if not scn:
        Scenario(name="Alpha Test").save()
        scn = Scenario.objects.filter(name="Alpha Test")

    print(f"{scn}")
    template = loader.get_template("home.html")
    context = {
        "scn": scn[0]
    }
    return HttpResponse(template.render(context, request))


def start(request):
    scn = Scenario.objects.filter(name="Alpha Test")
    if not scn:
        print(f"Unable to start scenario. Empty Database!")
        return HttpResponse("Error: Unable to start scenario. Empty Database!")
    else:
        scn = scn[0]
        scn_id = execution.create_execution(scn)
    return HttpResponse(f"Startet scenario: {scn.name} with id {scn_id}")


def end(request, scn_id):
    scn = execution.end_execution(scn_id)
    return HttpResponse(f"Ended scenario: {scn.name} with id {scn_id}")
