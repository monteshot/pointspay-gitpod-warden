# How to start the project
## To set the Variables you have to register at [Gitpod](https://gitpod.io/login) and/or any Gitpod on-premise plus install [Gitpod Chrome extension](https://chrome.google.com/webstore/detail/dodmmooeoklaejobgleioelladacbeki)
## To deploy the project at Gitpod, you must determine several GP settings variables:


1. Click on your profile image.  
    ![alt_text](.warden/images/image1.png "image_tooltip")

2. Click on the User Settings menu item  

    ![alt_text](.warden/images/image2.png "image_tooltip")


3. Click on the Variables menu entry. 

    ![alt_text](.warden/images/image3.png "image_tooltip")

4. Add the following Variable Name to your account. (If you need a clear magento use the [gitpod-manage-db-install.sh](.warden%2Fgitpod-manage-db-install.sh))

    ![alt_text](.warden/images/image4.png "image_tooltip")

    1. Notice: DOCKERD_ARGS could be used in global scope; defined once. 
5. Examples of the Variables
    1. AUTH_JSON 

    ![alt_text](.warden/images/image5.png "image_tooltip")

    2. DOCKERD_ARGS  
   ```json
    {"userns-remap":"1000"}
    ```
    ![alt_text](.warden/images/image6.png "image_tooltip")

    3. STORAGEBOX_HOST 

    ![alt_text](.warden/images/image7.png "image_tooltip")
   4. STORAGEBOX_USER

      ![alt_text](.warden/images/image11.png "image_tooltip")

   5. STORAGEBOX_PASS 

      ![alt_text](.warden/images/image8.png "image_tooltip")

   6. STORAGEBOX_SOURCE_PATH 

      ![alt_text](.warden/images/image9.png "image_tooltip")

      ![alt_text](.warden/images/image10.png "image_tooltip")

## To spin up the project use this button on appropriate branch

![alt_text](.warden/images/image16.png "image_tooltip")  

![alt_text](.warden/images/image17.png "image_tooltip")

## To restart the workspace use the "Open" button on the Gitpod dashboard  

![alt_text](.warden/images/image18.png "image_tooltip")


## To switch the websites use [COOKIE Editor extension](https://chrome.google.com/webstore/detail/hlkenndednhfkekhgcdicdfddnkalmdm)  

### Example of the COOKIE Editor extension  

1. Set XSTORE cookie to the value of the website you want to use. See the list of the websites below or in the file .warden/nginx/default.conf.template. 
    ![alt_text](.warden/images/image12.png "image_tooltip")
    1.1 Set the 'base' code to load the 'base' website.  
        ![alt_text](.warden/images/image13.png "image_tooltip")  
    1.2. Refresh the page.
    1.3. Set the 'other_code' code to load the 'other_code' website.  
              ![alt_text](.warden/images/image14.png "image_tooltip")  
    1.4. Refresh the page.

