import os
from random import randint

from asgi_htmx import HtmxMiddleware
from asgi_htmx import HtmxRequest as Request
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

basedir = os.path.abspath(os.path.dirname(__name__))
filedir = os.path.dirname(__file__)
template_folder = os.path.join(filedir, "templates")
templates = Jinja2Templates(directory=template_folder)

app = FastAPI()
app.add_middleware(HtmxMiddleware)


@app.get(path="/random-number", name="random-number", response_class=HTMLResponse)
async def random_number(request: Request):
    random_number = randint(1, 100)
    if htmx := request.scope["htmx"]:
        print(htmx.trigger, htmx.target)
        filename = "partials/number.html"
    else:
        filename = "random-number.html"
    return templates.TemplateResponse(
        filename,
        context={
            "request": request,
            "random_number": f"Random number: {random_number}",
        },
    )


@app.get(path="/dynamic-content", name="dynamic-content", response_class=HTMLResponse)
async def dynamic_content(request: Request):
    if request.scope["htmx"]:
        filename = "partials/dynamic-content.html"
    else:
        filename = "dynamic-content.html"
    return templates.TemplateResponse(
        filename,
        context={
            "request": request,
        },
    )


@app.get(path="/", name="root", response_class=HTMLResponse)
async def root(request: Request):
    return templates.TemplateResponse(
        "index.html",
        {
            "request": request,
        },
    )
